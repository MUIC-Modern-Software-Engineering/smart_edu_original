require "application_system_test_case"

class TeacherManagementsTest < ApplicationSystemTestCase
  setup do
    @school = School.create!(name: "Test School", address: "123 Test St", has_paid: 1)

    @admin = User.create!(
      first_name: "Admin",
      last_name: "User",
      email_address: "admin@test.com",
      role: "admin",
      approved: true,
      school_id: @school.id,
      personal_email: "admin@personal.com",
      password: "password123"
    )

    @admin.update(
      password: "password123"
    )


    @teacher = User.create!(
      email_address: "teacher@test.com",
      password: "password123",
      role: "teacher",
      approved: true,
      school_id: @school.id,
      personal_email: "teacher@personal.com",
      first_name: "Teacher",
      last_name: "User"
    )

    login_as(@admin)
  end

  test "should get index" do
    visit teachers_path
    assert_selector "h2", text: "Manage Teachers"
  end

  test "should be able to delete teacher" do
    visit teachers_path
    assert_selector "h2", text: "Manage Teachers"
    click_on "Remove", match: :first
    assert_selector ".modal-title", text: "Confirm Deletion"
    click_on "Yes, Remove"
    assert_selector ".alert"
  end
end
