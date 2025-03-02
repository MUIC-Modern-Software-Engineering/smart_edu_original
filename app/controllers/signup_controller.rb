class SignupController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    @user = User.new
  end

  def create
    ActiveRecord::Base.transaction do
      @user = User.new(user_params)

      if @user.save
        if @user.approved?
          start_new_session_for @user
          redirect_to after_authentication_url
        else
          flash[:notice] = "Your account is pending approval. Please wait for admin approval."
          redirect_to login_path
        end
      else
        render :new, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = "Error: #{e.message}"
    render :new
  end

  private

  def user_params
    permitted = params.require(:user).permit(:first_name, :last_name, :personal_email, :password, :password_confirmation, :school_id)
    role = params[:user][:role].to_s
    permitted[:role] = %w[teacher admin].include?(role) ? role : "teacher"
    permitted
  end
end
