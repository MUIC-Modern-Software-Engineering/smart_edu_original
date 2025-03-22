class SubscriptionMailer < ApplicationMailer
  default from: "smarteduccc@gmail.com"

  def reminder_email(user)
    @user = user
    mail(to: @user.email_address, subject: "Subscription Renewal Reminder")
  end
end
