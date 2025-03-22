require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @school = School.create!(name: "Test School", address: "123 Test St")

    @admin = User.create!(
      first_name: "Admin",
      last_name: "User",
      email_address: "admin@test.com",
      personal_email: "admin@personal.com",
      role: "admin",
      approved: true,
      school_id: @school.id,
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

    @principal = User.create!(
      first_name: "School",
      last_name: "Principal",
      email_address: "principal@test.com",
      personal_email: "principal@personal.com",
      role: "principal",
      approved: true,
      school_id: @school.id,
      password: "password123"
    )

    sign_in_with_parameter(@admin)
  end

  test "should get index" do
    get users_path
    assert_response :success
  end

  test "non-admin cannot access index" do
    regular_user = User.create!(
      first_name: "Regular",
      last_name: "User",
      email_address: "regular@test.com",
      personal_email: "regular@personal.com",
      role: "teacher",
      approved: true,
      school_id: @school.id,
      password: "password123"
    )

    sign_in_with_parameter(regular_user)
    get users_path
    assert_redirected_to root_path
    assert_equal "You are not authorized to access this page.", flash[:alert]
  end

  test "should approve user" do
    assert_difference -> { User.where(approved: true).count } do
      patch approve_user_path(@pending_user)
    end
    assert_redirected_to users_path
    assert_equal "#{@pending_user.email_address} has been approved.", flash[:notice]
  end

  test "should create principal-teacher relationship when approving teacher" do
    assert_difference "PrincipalTeacherRelationship.count" do
      patch approve_user_path(@pending_user)
    end

    relationship = PrincipalTeacherRelationship.last
    assert_equal @principal.id, relationship.principal_id
    assert_equal @pending_user.id, relationship.teacher_id
  end

  test "should not approve user from different school" do
    other_school = School.create!(name: "Other School", address: "456 Other St")
    @pending_user.update!(school_id: other_school.id)

    patch approve_user_path(@pending_user)
    assert_redirected_to users_path
    assert_equal "You can only approve users from your school.", flash[:alert]
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete user_path(@pending_user)
    end
    assert_redirected_to users_path
    assert_equal "#{@pending_user.email_address} has been removed.", flash[:notice]
  end

  test "should handle JSON format" do
    get users_path, as: :json
    assert_response :success
  end
end
