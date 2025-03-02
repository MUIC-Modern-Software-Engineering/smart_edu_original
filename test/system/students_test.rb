require "application_system_test_case"

class StudentsTest < ApplicationSystemTestCase
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
    @classroom2 = Classroom.create!(
        grade_level: 6,
        class_id: "MATH102",
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
    student_email_address: @user.email_address,  # ✅ Ensure correct linking
    parent_email_address: "parenttest@example.com"
  )
    login_as_principal
  end
  def login_as_principal
    visit new_session_url
    fill_in "email_address", with: @principal.email_address
    fill_in "password", with: "securepassword"
    click_on "Sign in"
    assert_selector "h2 span", text: "Dashboard"
  end

  test "visiting the index" do
    visit students_url
    assert_selector "h2", text: "Students"
  end

test "should create student" do
  visit students_url
  click_on "New student"

  fill_in "First Name", with: "Test"
  fill_in "Last Name", with: "Student"
  fill_in "Grade", with: @classroom.grade_level
  puts @classroom.grade_level
  fill_in "Classroom", with: @classroom.class_id
  puts @classroom.id
  fill_in "Personal Email Address", with: "student#{SecureRandom.hex(4)}@example.com"
  fill_in "Parent Email Address", with: "parenttest@example.com"

  click_on "Create Student"

  assert_text "Student was successfully created"
  assert_text "Test Student"
end
  test "should update student" do
    visit student_url(@student)
    click_on "Edit", match: :first
    fill_in "First Name", with: "Edited"
    fill_in "Last Name", with: "Student"
    fill_in "Grade", with: @classroom2.grade_level
    fill_in "Classroom", with: @classroom2.class_id
    fill_in "Personal Email Address", with: @student.student_email_address
    fill_in "Parent Email Address", with: @student.parent_email_address

    click_on "Update Student"
    assert_text "Student was successfully updated"
    assert_text "Edited Student"
    click_on "Back"
  end

  test "should archive student (destroy)" do
    visit student_url(@student)

    click_on "Delete", match: :first
    page.driver.browser.switch_to.alert.accept  # Accept the JavaScript confirmation

    assert_text "#{@student.name} was archived successfully." # Wait for UI confirmation
    sleep 1 # Wait for the database to update

    @student.reload
    assert_equal false, @student.is_active, "Student should be archived but is still active"
    assert_text "#{@student.name} was archived successfully."
  end
end
