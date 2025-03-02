class ApplicationController < ActionController::Base
  include Authentication
  helper :qr

  before_action :set_current_user
  before_action :set_classroom

  private

  def set_current_user
    if Current.session
      @current_user = Current.session.user
      Rails.logger.info "DEBUG: Current user = #{@current_user&.email_address}"
    else
      Rails.logger.info "DEBUG: No active session"
    end
  end

  def set_classroom
    if current_user
      student = Student.find_by(student_email_address: current_user.email_address)

      # Debugging: Log the student and classroom_id
      Rails.logger.info "DEBUG: Student record: #{student.inspect}"

      if student
        @classroom = Classroom.find_by(id: student.classroom_id)


        # Debugging: Log the classroom found
        # Rails.logger.info "DEBUG: Classroom found: #{@classroom.inspect}"
      else
        Rails.logger.info "DEBUG: No student found for user #{current_user.email_address}"
      end
    end
  end


  helper_method :current_user

  def current_user
    @current_user
  end
end
