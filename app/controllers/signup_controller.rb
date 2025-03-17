class SignupController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    @user = User.new
  end

  def create
    if User.exists?(personal_email: params[:user][:personal_email])
      flash[:error] = "A user with this personal email already exists. Please use a different email."
      redirect_to new_signup_path and return
    end

    ActiveRecord::Base.transaction do
      @user = User.new(user_params)

      if @user.save
        if @user.approved?
          start_new_session_for @user
          redirect_to after_authentication_url
        else
          flash[:notice] = "Your account is pending approval. \n\n
                            Your school email and password have been sent to your personal email."
          redirect_to login_path
        end
      else
        flash[:error] = "Please check the form for errors."
        Rails.logger.error "Signup failed: #{@user.errors.full_messages.join(', ')}"
        render :new, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = "Error: #{e.message}"
    Rails.logger.error "Signup Exception: #{e.message}"
    render :new
  end

  private

  def user_params
    permitted = params.require(:user).permit(:first_name, :last_name, :personal_email, :school_id)
    role = params[:user][:role].to_s
    permitted[:role] = %w[teacher admin].include?(role) ? role : "teacher"
    permitted
  end
end
