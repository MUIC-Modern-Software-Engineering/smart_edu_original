class TeachersController < ApplicationController
  before_action :authorize_admin!, only: %i[ index destroy ]

  def index
    @teachers = User.where(role: "teacher", school_id: current_user.school_id, approved: true)
                    .select(:id, :first_name, :last_name, :email_address, :personal_email)
  end

  def destroy
    teacher = User.find(params[:id])

    if teacher.destroy
      redirect_to teachers_path, notice: "#{teacher.email_address} has been removed."
    else
      redirect_to teachers_path, alert: "Failed to remove teacher."
    end
  end

  private

  def authorize_admin!
    puts "Current User: #{current_user.inspect}"
    unless current_user.admin?
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end
