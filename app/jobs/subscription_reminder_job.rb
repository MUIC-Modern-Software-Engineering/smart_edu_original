class SubscriptionReminderJob < ApplicationJob
  queue_as :default

  def perform
    Payment.where("subscription_end < ?", 1.week.from_now).find_each do |payment|
      SubscriptionMailer.reminder_email(payment.user).deliver_later
    end
  end
end
