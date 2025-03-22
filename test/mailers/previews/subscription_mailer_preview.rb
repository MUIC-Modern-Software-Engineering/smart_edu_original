# Preview all emails at http://localhost:3000/rails/mailers/subscription_mailer
class SubscriptionMailerPreview < ActionMailer::Preview
  def reminder_email
    SubscriptionMailer.with(user: User.first).reminder_email
  end
end
