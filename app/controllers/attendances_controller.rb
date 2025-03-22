class AttendancesController < ApplicationController
  before_action :set_attendance, only: %i[show edit update destroy]
  before_action :authorize_admin_or_principal_or_system_or_teacher!
  include Pagy::Backend

  # GET /attendances or /attendances.json
  def index
    @attendances = Attendance.all
  end

  # GET /attendances/1 or /attendances/1.json
  def show
    # This will render app/views/attendances/show.html.erb
  end

  # GET /attendances/new
  def new
    @q = Student.active.ransack(params[:q])
    @students = @q.result(distinct: true)
    @attendances = Attendance.order(timestamp: :desc).limit(10)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /attendances/1/edit
  def edit
    # This will render app/views/attendances/edit.html.erb
  end

  # POST /attendances or /attendances.json
  def create
    student = Student.find(params[:student_id])

    existing_attendance = Attendance.where(student: student)
                                    .where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
                                    .first

    if existing_attendance
      existing_attendance.destroy!
      render json: { status: "Destroy!" }, status: :ok
    else
      CheckinService.checkin(student, Current.user)
      render json: { status: "success" }, status: :ok
    end
  end

  # PATCH/PUT /attendances/1 or /attendances/1.json
  def update
    respond_to do |format|
      if @attendance.update(attendance_params)
        format.html { redirect_to @attendance, notice: "Attendance was successfully updated." }
        format.json { render :show, status: :ok, location: @attendance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendances/1
  def destroy
    @attendance.destroy!
    respond_to do |format|
      format.html { redirect_to attendances_path, status: :see_other, notice: "Attendance was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def scan_qr
    # This will render app/views/admin/scan_qr.html.erb
  end

  # Check-in logic
  def checkin
    qr_data = params[:qr_data] # Expecting "student_id|school_id"
    student_id, scanned_school_id = qr_data.split("|").map(&:to_i)

    student = Student.find_by(id: student_id)

    if student.nil?
      render json: { success: false, message: "Invalid student ID." }, status: :unprocessable_entity
      return
    end

    user = User.find_by(email_address: student.student_email_address)

    if user.nil?
      render json: { success: false, message: "Student's associated user not found." }, status: :unprocessable_entity
      return
    end

    # Ensure the scanned school_id matches the user's school_id
    if user.school_id != scanned_school_id
      render json: { success: false, message: "School mismatch. Unauthorized check-in." }, status: :forbidden
      return
    end

    # Ensure current user is from the same school
    if current_user.school_id != user.school_id
      render json: { success: false, message: "Unauthorized. School mismatch." }, status: :forbidden
      return
    end

    # Prevent duplicate check-ins
    existing_attendance = Attendance.find_by(
      student: student,
      created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
    )

    if existing_attendance
      render json: { success: false, message: "Student already checked in today." }
      return
    end

    # Create new attendance record
    attendance = Attendance.create(student: student, timestamp: Time.current, user: current_user)

    if attendance.persisted?
      if student.user.school == 2
        AttendanceMailer.check_in_notification(student, attendance).deliver_later
        message = "Student checked in successfully at #{Time.current.strftime('%I:%M:%S')}. Parent has been notified."
      else
        respond_to do |format|
          format.json { render json: { success: false, message: message } }
        end
      end

      respond_to do |format|
        format.json { render json: { success: true, message: message } }
        format.html { redirect_to admin_scan_qr_path, notice: message }
      end
    else
      message = "Check-in failed."
      respond_to do |format|
        format.json { render json: { success: false, message: message } }
        format.html { redirect_to admin_scan_qr_path, alert: message }
      end
    end
  end

  # Check if a student has checked in today
  def check_if_checked_in
    Rails.logger.info("Checking if student is checked in")
    student = Student.find_by(id: params[:attendance_id])

    unless student
      render json: { checked_in: false, message: "Student not found" }, status: :not_found
      return
    end

    checked_in = Attendance.exists?(
      student: student,
      created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
    )

    render json: { checked_in: checked_in }
  end

  # Check if a student is checked in and authorized
  def status
    Rails.logger.info("Checking if student is checked in and authorized")
    student = Student.find_by(id: params[:attendance_id])

    unless student
      render json: { status: "error", message: "Student not found" }, status: :not_found
      return
    end

    checked_in = Attendance.exists?(
      student: student,
      created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
    )

    classroom_id = student.classroom_id
    homeroom = Homeroom.find_by(classroom_id: classroom_id)
    teacher_id = homeroom&.teacher_id

    authorized = current_user.system? || (current_user.teacher? && current_user&.id == teacher_id)

    Rails.logger.info("Authorized: #{authorized} Checked In: #{checked_in}")

    render json: { checked_in: checked_in, authorized: authorized }
  end

  private

  def set_attendance
    @attendance = Attendance.find(params[:id])
  end

  def attendance_params
    params.require(:attendance).permit(:student_id, :timestamp, :user_id)
  end

  def authorize_admin_or_principal_or_system_or_teacher!
    unless current_user.admin? || current_user.principal? || current_user.system? || current_user.teacher?
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end
