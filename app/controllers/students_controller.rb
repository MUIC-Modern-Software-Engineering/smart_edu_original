class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show edit update destroy ]
  before_action :set_student, only: [ :show, :edit, :update, :destroy ]
  attr_reader :student # helps with testing
  attr_reader :students
  include Pagy::Backend
  def index
    @grades = Student.distinct.pluck(:grade).compact.sort

    students_scope = Student.active
    students_scope = students_scope.where(grade: params[:grade]) if params[:grade].present?
    @pagy, @students = pagy(students_scope)
  end


  # GET /students/1 or /students/1.json
  def show
    @student = Student.kept.find(params[:id]) # Fetch the student by ID from the database
    respond_to do |format|
      format.html { render "show" }
      format.js
      format.json { render json: @student }
    end
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  def edit; end
  # POST /students or /students.json
  def create
    classroom = Classroom.find_by(class_id: params[:student][:classroom_id])

    if classroom.nil?
      flash[:error] = "Classroom not found"
      render :new, status: :unprocessable_entity and return
    end

    @student = Student.new(student_params.merge(classroom_id: classroom.id))

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.update(is_active: false) # Archive the student instead of deleting

    respond_to do |format|
      format.html { redirect_to students_path, notice: "#{@student.name} was archived successfully." }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def student_params
      params.require(:student).permit(:name, :is_active, :grade, :classroom_id, :student_email_address, :parent_email_address)
    end

    def archive
      @student = Student.find(params[:id])
      if @student.update(is_active: false)
        redirect_to students_path, notice: "#{@student.name} has been archived."
      else
        redirect_to students_path, alert: "Failed to archive student."
      end
    end

  def activate
    @student = Student.find(params[:id])
    if @student.update(is_active: true)
      redirect_to students_path, notice: "#{@student.name} has been reactivated."
    else
      redirect_to students_path, alert: "Failed to activate student."
    end
  end

  def manage
    @pagy, @students = pagy(Student.all) # Show both active and archived students
  end
end
