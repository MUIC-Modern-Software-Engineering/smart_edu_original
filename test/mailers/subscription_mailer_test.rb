require "test_helper"

class SubscriptionMailerTest < ActionMailer::TestCase
  setup do
    @user = FactoryBot.create(:user)
  end

  test "reminder_email" do
    mail = SubscriptionMailer.reminder_email(@user)

    assert_equal "Subscription Renewal Reminder", mail.subject
    assert_equal [ @user.email_address ], mail.to
    assert_equal [ "smarteduccc@gmail.com" ], mail.from

    assert_match(/Dear/, mail.body.encoded)
    assert_match(/subscription/, mail.body.encoded)
  end
end
