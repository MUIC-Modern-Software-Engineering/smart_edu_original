class ClassroomsController < ApplicationController
  before_action :set_classroom, only: [ :show, :grading ]
  before_action :authorize_admin_or_teacher_or_principal!

  def index
    @classrooms = Classroom.all.order(:class_id)

    # make sure that the student + admin can access the grade from the nav_bar
    @classroom = Classroom.first
  end

  def show
    # If the user is an admin, they can see any classroom
    if current_user&.admin?
      @classroom = Classroom.first
    end
    # for students
    @classroom = Classroom.find(params[:id])
    @students = @classroom.students.where(grade: @classroom.grade_level).order(:name)
  end

  # Grading action for displaying students and their grades
  def grading
    @classroom = Classroom.find(params[:id])
    @grades = Student.distinct.where.not(grade: nil).pluck(:grade).compact.sort

    @students_by_grade = @grades.map do |grade|
      {
        grade: grade,
        students: @classroom.students.where(grade: grade).where.not(grade: nil)
      }
    end
  end

  def by_grade
    @classroom = Classroom.first
    @grade = params[:grade] # Ensure @grade is set from params

    if @grade.blank?
      flash[:alert] = "Grade is missing."
      redirect_to classrooms_path and return
    end

    Rails.logger.debug "DEBUG: is checking grade" # Check if grade is properly set

    @classrooms = Classroom.where("grade_level LIKE ?", "#{@grade}%").order(:class_id)

    Rails.logger.debug "DEBUG: @grade = #{@grade}" # Check if grade is properly set
    Rails.logger.debug "DEBUG: @classrooms = #{@classrooms}" # Check fetched classrooms
  end

  private

  # This method is called before both show and grading actions to find the classroom
  def set_classroom
    @classroom = Classroom.find(params[:id])
  end

  def grade_level
    @classroom = Classroom.find(params[:id])
    @students_by_grade = @classroom.students.group_by(&:grade)
  end

  def authorize_admin_or_teacher_or_principal!
    unless current_user.admin? || current_user.teacher? || current_user.principal?
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end
