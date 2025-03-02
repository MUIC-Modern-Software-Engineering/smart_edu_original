class TeachersController < ApplicationController
  before_action :authenticate_admin_or_principal!

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

  def authenticate_admin_or_principal!
    unless current_user.admin? || current_user.principal?
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end
