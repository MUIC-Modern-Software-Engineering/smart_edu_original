require "rails_helper"

RSpec.describe SubscriptionReminderJob, type: :job do
  include FactoryBot::Syntax::Methods

  # define two users
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:payment) { create(:payment, user: user, subscription_end: 6.days.from_now) }
  let!(:future_payment) { create(:payment, user: user2, subscription_end: 2.weeks.from_now) }

  # make sure that it sends to only the user with the expiring subscription
  it "sends reminder emails to users with expiring subscriptions" do
    expect {
      SubscriptionReminderJob.perform_now
    }.to have_enqueued_mail(SubscriptionMailer, :reminder_email).with(user).once
  end
end
