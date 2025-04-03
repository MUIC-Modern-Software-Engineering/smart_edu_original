# test/test_helper_extensions.rb
module AuthenticationHelper
  def sign_in(user)
    post new_session_url, params: { email_address: user.email_address, password: "password" }
    assert_
  end
end
