require "test_helper"

class StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @school = School.create!(name: "Test School", address: "123 Main St")

    @principal = User.create!(
      first_name: "Principal",
      last_name: "Test",
      personal_email: "principal_#{SecureRandom.hex(4)}@gmail.com",
      role: "principal",
      password: "securepassword",
      school_id: @school.id
    )

    @classroom = Classroom.create!(
      grade_level: 5,
      class_id: "MATH101",
      school_id: @school.id
    )

    @user = User.create!(
      first_name: "Test",
      last_name: "Student",
      personal_email: "test_student_#{SecureRandom.hex(4)}@gmail.com",
      role: "student",
      password: "securepassword",
      school_id: @school.id
    )

    @student = Student.create!(
      name: "#{@user.first_name} #{@user.last_name}",
      grade: @classroom.grade_level,
      classroom_id: @classroom.id,
      student_email_address: @user.email_address,
      parent_email_address: "parenttest@example.com"
    )

    sign_in()
  end

test "should create student" do
  assert_difference([ "Student.count", "User.count" ]) do
    post students_url, params: { student: {
      first_name: "John",
      last_name: "Doe",
      grade: @classroom.grade_level,
      classroom_id: @classroom.class_id,  # Pass class_id (not id)
      personal_email: "personal_#{SecureRandom.hex(4)}@gmail.com",
      parent_email_address: "parent.doe@example.com"
    } }
  end

  student = Student.last
  user = User.find_by(email_address: student.student_email_address)

  assert_not_nil user
  assert_redirected_to student_url(student)
end

test "should show student" do
  get student_url(@student)
  assert_response :success
end

test "should get new" do
  get new_student_url
  assert_response :success
end

test "should get edit" do
  get edit_student_url(@student)
  assert_response :success
end

test "should update student" do
  patch student_url(@student), params: { student: {
    first_name: "Jane",
    last_name: "Doe",
    grade: @classroom.grade_level,
    classroom_id: @classroom.class_id,
    personal_email: "updated_personal_#{SecureRandom.hex(4)}@gmail.com",
    parent_email_address: @student.parent_email_address
  } }

  @student.reload
  assert_equal "Jane Doe", @student.name
  assert_redirected_to student_url(@student)
end

test "should archive student after deletion" do
  delete student_url(@student)

  @student.reload
  assert_equal false, @student.is_active, "Student was not archived"
  assert_redirected_to students_path
  assert_equal "#{@student.name} was archived successfully.", flash[:notice]
end
end
