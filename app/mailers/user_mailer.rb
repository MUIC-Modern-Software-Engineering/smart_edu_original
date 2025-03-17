class UserMailer < ApplicationMailer
  default from: "smarteduccc@gmail.com"

  def send_login_credentials(user, generated_password)
    @user = user
    @password = generated_password  # Store password to send in email

    mail(
      to: @user.personal_email,
      subject: "Your School Login Credentials"
    )
  end
end
