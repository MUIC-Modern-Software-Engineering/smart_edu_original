every 1.day, at: "12:00 am" do
  runner "SubscriptionReminderJob.perform_later"
end
