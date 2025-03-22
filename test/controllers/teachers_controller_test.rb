require "test_helper"

class TeachersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @school = School.create!(name: "Test School", address: "123 Test St")
    @other_school = School.create!(name: "Other School", address: "234 Test Rd.")

    @user = User.create!(
      first_name: "Admin",
      last_name: "User",
      email_address: "admin@test.com",
      role: "admin",
      approved: true,
      school_id: @school.id,
      personal_email: "admin@personal.com"
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

    @other_teacher = User.create!(
      email_address: "teacher2@test.com",
      password: "password123",
      role: "teacher",
      approved: true,
      school_id: @other_school.id,
      personal_email: "teacher2@personal.com",
      first_name: "Teacher",
      last_name: "User"
    )

    sign_in_with_parameter(@user)
  end

  test "should get index" do
    get teachers_path
    assert_response :success, "Admin could not access teachers index"
  end

  test "should destroy teacher with the same school id" do
    delete teacher_path(@teacher)
    assert_response :redirect, "Delete failed with response: #{response.body}"
    follow_redirect!
    assert_response :success
  end

  test "shouldn't destroy teacher with different school id" do
    delete teacher_path(@other_teacher)
    assert_response :redirect, "Delete failed with response: #{response.body}"
  end
end
