class SignupController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      if @user.approved?
        start_new_session_for @user
        redirect_to after_authentication_url
      else
        flash[:notice] = "Your account is pending approval. Please wait for admin approval."
        redirect_to root_path
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    permitted = params.require(:user).permit(:email_address, :password, :password_confirmation)
    permitted[:role] = params[:user].fetch(:role, "student") if %w[student teacher].include?(params[:user][:role].to_s)
    permitted
  end
end
