require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index when logged in" do
    sign_in
    get root_path
    assert status, 200
    assert_includes @response.body, "Total Students"
  end

  # test "not logged in should get redirected to login" do
  #   get root_path
  #   assert_redirected_to new_session_path
  # end

  # private

  def sign_in
    user = User.find_by!(role: "principal")
    post session_url, params: { email_address: user.email_address, password: "password123" }
  end
end
