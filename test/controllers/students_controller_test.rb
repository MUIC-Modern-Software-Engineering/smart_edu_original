require "test_helper"

class StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student = Student.first
    sign_in
  end

  test "should get index" do
    get students_url
    assert_response :success
  end

  test "should get new" do
    get new_student_url
    assert_response :success
  end

  test "should create student" do
    assert_difference("Student.count", 1) do
      post students_url, params: { student: { name: "newstudent", is_active: 1, grade: 5, classroom_id: "5A", student_email_address: "student3@example.com", parent_email_address: @student.parent_email_address } }
    end
    assert_redirected_to student_url(Student.last)
  end

  test "should show student" do
    get student_url(@student)
    assert_equal @controller.student.id, @student.id
    assert_response :success
  end

  test "should get edit" do
    get edit_student_url(@student)
    assert_response :success
  end

  test "should update student" do
    # print all the student attributes
    patch student_url(@student), params: { student: { name: "newname", is_active: 1, grade: @student.grade, classroom_id: @student.classroom_id, student_email_address: @student.student_email_address, parent_email_address: @student.parent_email_address } }
    assert_redirected_to student_url(@student)
  end


  test "archive student after deletion" do
    delete student_url(@student)
    @student.reload
    # Assert that the student is archived (is_active should be true)
    assert_equal false, @student.is_active?, "Student was not archived"

    # Assert the correct redirect after the action
    assert_redirected_to students_path

    # Assert the flash message is correct
    assert_equal "#{@student.name} was archived successfully.", flash[:notice]
  end
end
