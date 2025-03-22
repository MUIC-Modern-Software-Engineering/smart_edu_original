module SystemTestHelper
  def login_as(user)
    visit new_session_path
    fill_in "email_address", with: user.email_address
    fill_in "password", with: "password123"
    click_on "Sign In"
    assert_selector "h2 span", text: "Dashboard", wait: 10
  end
end
