require "test_helper"

class StudentPrivilegesTest < ActionDispatch::IntegrationTest
  setup do
    @eiei_school = School.create!(name: "Test School", address: "123 Main St")
    @yoyo_school = School.create!(name: "Yoyo School", address: "123 Main St")

    @principal = User.create!(
      first_name: "Principal",
      last_name: "Test",
      personal_email: "principal_#{SecureRandom.hex(4)}@gmail.com",
      role: "principal",
      password: "password123",
      school_id: @eiei_school.id
    )

    @classroom = Classroom.create!(
      grade_level: 5,
      class_id: "MATH101",
      school_id: @eiei_school.id
    )

    @yoyo_classroom = Classroom.create!(
      grade_level: 6,
      class_id: "MATH102",
      school_id: @yoyo_school.id
    )

    @user = User.create!(
      first_name: "Test#{SecureRandom.hex(2)}",
      last_name: "Student#{SecureRandom.hex(2)}",
      personal_email: "test_student_#{SecureRandom.hex(4)}@gmail.com",
      role: "student",
      password: "password123",
      approved: true,
      school_id: @eiei_school.id
    )

    @student = Student.create!(
      name: "#{@user.first_name} #{@user.last_name}",
      grade: @classroom.grade_level,
      classroom_id: @classroom.id,
      student_email_address: @user.email_address,
      parent_email_address: "parenttest@example.com"
    )
  end

  test "should get profile" do
    sign_in_with_parameter(@user)
    get profile_url
    assert_response :success
  end
end
