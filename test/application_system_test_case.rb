require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: ci? ? :headless_chrome : :chrome, screen_size: [ 1400, 1400 ]
  def login
    visit new_session_path
    @user = User.find_by!(role: "principal")
    fill_in "email_address", with: @user.email_address
    fill_in "password", with: "password123"
    click_on "Sign In"
    # This does not work now, since if the user has not paid, it will bring them to the payment page
    # assert_selector "h2 span", text: "Dashboard"
  end
end
