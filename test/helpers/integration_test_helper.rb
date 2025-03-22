module IntegrationTestHelper
  def sign_in
    user = User.find_by!(role: "principal")
    post session_path, params: {
      email_address: user.email_address,
      password: "password123",
      school_id: user.school_id
    }
    follow_redirect!
    assert_response :success, "Login failed: #{response.body}"
  end

  def sign_in_with_parameter(user)
    post session_path, params: {
      email_address: user.email_address,
      password: user.password,
      school_id: user.school_id
    }
    follow_redirect!
    assert_response :success, "Login failed: #{response.body}"
  end
end
