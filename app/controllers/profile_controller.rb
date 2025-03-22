class ProfileController < ApplicationController
  before_action :authorize_user!

  def show
    @user = current_user
    @student = Student.find_by(student_email_address: @user.email_address) if @user.student?
    render "profiles/show"
  end

  def update_password
    @user = current_user
    if @user.update(password_params)
      redirect_to profile_path, notice: "Password updated successfully."
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :show
    end
  end

  private
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def authorize_user!
    unless current_user.student? || current_user.teacher? || current_user.admin? || current_user.principal?
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end
