class AttendancesController < ApplicationController
  before_action :set_attendance, only: %i[ show edit update destroy ]
  include Pagy::Backend

  # GET /attendances or /attendances.json
  #
  def index
    @q = Attendance.ransack(params[:q])
    @pagy, @attendances = pagy(@q.result(distinct: true))
  end


  # GET /attendances/1 or /attendances/1.json
  def show
  end

  # GET /attendances/new
  def new
    @q = Student.ransack(params[:q])
    @students = @q.result(distinct: true)
    @attendances = Attendance.order(timestamp: :desc).limit(20).includes(:student)
    respond_to do |format|
      format.html # For normal page loads
      format.turbo_stream # For Turbo-powered live updates
    end
  end

  # GET /attendances/1/edit
  def edit
  end

  # POST /attendances or /attendances.json
  def create
    p = params.permit(:student_id).merge(user_id: Current.user.id, timestamp: Time.zone.now)
    @attendance = Attendance.new(p)
    @attendance.save!
    respond_to do |format|
      format.html { redirect_to new_attendance_path(request.parameters) } # For normal page loads
      format.turbo_stream { redirect_to new_attendance_path(request.parameters) }# For Turbo-powered live updates
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

  # DELETE /attendances/1 or /attendances/1.json
  def destroy
    @attendance.destroy!

    respond_to do |format|
      format.html { redirect_to attendances_path, status: :see_other, notice: "Attendance was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendance
      @attendance = Attendance.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def attendance_params
      params.expect(attendance: [ :student_id, :timestamp, :user_id ])
    end
end
