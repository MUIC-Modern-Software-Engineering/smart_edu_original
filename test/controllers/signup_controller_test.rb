require "test_helper"

class SignupControllerTest < ActionDispatch::IntegrationTest
  setup do
    @eiei_school = School.create!(name: "Test School", address: "123 Main St")
  end

  test "should get new" do
    get new_signup_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post signup_index_url, params: { user: { first_name: "Test",
                                          last_name: "User",
                                          personal_email: "test@example.com",
                                          role: "teacher",
                                          school_id: @eiei_school.id } }
    end
  end

  # test "should send welcome email after signup" do
  #   assert_emails 1 do
  #     post signup_index_url, params: {
  #       user: {
  #         first_name: "Test",
  #         last_name: "User",
  #         personal_email: "test@example.com",
  #         role: "teacher",
  #         school_id: @eiei_school.id
  #       }
  #     }
  #   end
  #
  #   email = ActionMailer::Base.deliveries.last
  #   assert_equal [ "test@example.com" ], email.to
  #   assert_equal "Your School Login Credentials", email.subject
  #   body =  email.body.to_s
  #   user = User.last
  #   assert_match user.email_address, body
  #   assert_match "Hello #{user.first_name}", body
  # end

  test "should not send email if signup fails" do
    assert_no_emails do
      post signup_index_url, params: {
        user: {
          first_name: "Test",
          role: "teacher",
          school_id: @eiei_school.id
        }
      }
    end
  end
end
