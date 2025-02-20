require "application_system_test_case"

class StudentsTest < ApplicationSystemTestCase
  def login
    visit new_session_url
    @user = User.find_by!(role: "principal")
    fill_in "email_address", with: @user.email_address
    fill_in "password", with: "password123"
    click_on "Sign in"
    assert_selector "h2 span", text: "Dashboard"
    end

  setup do
    @student = Student.first
    login
  end

  test "visiting the index" do
    visit students_url
    assert_selector "h2", text: "Students"
  end

  test "should create student" do
    visit students_url
    click_on "New student"
    fill_in "Name", with: "testStudent"
    fill_in "Grade", with: 5
    fill_in "Classroom", with: "5A"

    fill_in "Student email address", with: "student3@example.com"
    fill_in "Parent email address", with: "parenttest@example.com"

    click_on "Create Student"
    assert_text "Student was successfully created"
    assert_text "testStudent"  # Ensure the new student's name is displayed
  end


  test "should update student" do
    visit student_url(@student)
    click_on "Edit", match: :first
    fill_in "Name", with: "editedStudent"
    fill_in "Grade", with: 6
    fill_in "Classroom", with: 1
    puts "Student Email: #{@student.student_email_address}"
    puts "Parent Email: #{@student.parent_email_address}"
    fill_in "Student email address", with: @student.student_email_address
    fill_in "Parent email address", with: @student.parent_email_address

    click_on "Update Student"
    assert_text "Student was successfully updated"
    assert_text "editedStudent" # Ensure the updated name is displayed
    click_on "Back"
  end

  test "should archive student (destroy)" do
    visit student_url(@student)
    accept_alert do
      click_on "Delete", match: :first
    end
    @student.reload
    assert_equal true, @student.is_active
    assert_text "#{@student.name} was archived successfully."
  end
end
