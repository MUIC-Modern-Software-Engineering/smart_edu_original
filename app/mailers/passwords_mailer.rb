class PasswordsMailer < ApplicationMailer
  # default from: "smarteduccc@gmail.com"
  def reset(user)
    @user = user
    mail(
      to: @user.personal_email,
      subject: "Reset your password"
    )
  end
end
