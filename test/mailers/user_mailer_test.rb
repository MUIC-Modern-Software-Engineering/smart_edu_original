require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  setup do
    @school = School.create!(name: "Test School", address: "123 Test St", has_paid: 1)
    @user = User.create!(
      first_name: "Test",
      last_name: "User",
      personal_email: "test@example.com",
      role: "teacher",
      school_id: @school.id
    )
  end

  test "should send credentials" do
    generated_password = SecureRandom.hex(8)

    email = UserMailer.send_login_credentials(@user, generated_password)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ "test@example.com" ], email.to
    assert_equal [ "smarteduccc@gmail.com" ], email.from
    assert_equal "Your School Login Credentials", email.subject

    body = email.body.to_s
    assert_match @user.email_address, body
    assert_match generated_password, body
    assert_match "Hello #{@user.first_name}", body
  end
end
