require "application_system_test_case"

class UserApprovalsTest < ApplicationSystemTestCase
  setup do
    @school = School.create!(name: "Test School", address: "123 Test St", has_paid: 1)

    @admin = User.create!(
      first_name: "Admin",
      last_name: "User",
      email_address: "admin@test.com",
      role: "admin",
      approved: true,
      school_id: @school.id,
      personal_email: "admin@personal.com"
    )

    @admin.update(
      password: "password123"
    )

    @pending_user = User.create!(
      first_name: "Pending",
      last_name: "User",
      email_address: "pending@test.com",
      personal_email: "pending@personal.com",
      role: "teacher",
      approved: false,
      school_id: @school.id,
      password: "password123"
    )
  end

  test "visiting the index" do
    login_as(@admin)
    visit users_path
    assert_selector "h2", text: "Manage Users"
  end

  test "should be able to approve" do
    login_as(@admin)
    visit users_path
    assert_selector "h2", text: "Manage Users"

    click_on "Approve", match: :first
    assert_selector ".modal-title", text: "Confirm Approval"
    click_on "Yes, Approve"
    assert_selector ".alert", text: "#{@pending_user.email_address} has been approved"
    assert @pending_user.reload.approved?
  end

  test "should be able to disapprove" do
    login_as(@admin)
    visit users_path
    assert_selector "h2", text: "Manage Users"

    click_on "Remove", match: :first
    assert_selector ".modal-title", text: "Confirm Deletion"
    click_on "Yes, Remove"
    assert_selector ".alert", text: "#{@pending_user.email_address} has been removed"
    assert_not User.exists?(@pending_user.id)
  end
end
