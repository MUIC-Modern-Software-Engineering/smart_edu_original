require "test_helper"

class StudentsControllerTest < ActionDispatch::IntegrationTest
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
      school_id: @eiei_school.id
    )

    @student = Student.create!(
      name: "#{@user.first_name} #{@user.last_name}",
      grade: @classroom.grade_level,
      classroom_id: @classroom.id,
      student_email_address: @user.email_address,
      parent_email_address: "parenttest@example.com"
    )

    sign_in_with_parameter(@principal)
  end

  test "should create student" do
    @user = User.create!(
      first_name: "John",
      last_name: "Doe",
      personal_email: "personal_#{SecureRandom.hex(4)}@gmail.com",
      role: "student",
      password: "securepassword",
      school_id: @eiei_school.id
    )

    @student = Student.create!(
      name: "John Doe",
      grade: @classroom.grade_level,
      classroom_id: @classroom.id,
      student_email_address: @user.email_address,
      parent_email_address: "parent.doe@example.com"
    )

    student = Student.find_by(student_email_address: @user.email_address)
    user = User.find_by(email_address: @user.email_address)

    assert_not_nil student, "Student was not created"
    assert_not_nil user, "User was not created"
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
      classroom_id: @classroom.id,
      personal_email: "updated_personal_#{SecureRandom.hex(4)}@gmail.com",
      parent_email_address: @student.parent_email_address
    } }

    if @student.errors.any?
      puts @student.errors.full_messages
    end

    @student.reload
    assert_equal "Jane Doe", @student.name
    assert_redirected_to student_url(@student)
  end

  test "should archive student after deletion" do
    delete student_url(@student)

    @student.reload
    assert_equal false, @student.is_active, "Student was not archived"
    assert_redirected_to students_path
    assert_equal "#{@student.name} was successfully archived.", flash[:notice]
  end
end
