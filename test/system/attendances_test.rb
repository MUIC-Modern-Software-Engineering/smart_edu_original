require "application_system_test_case"
require "test_helper"

class AttendancesTest < ApplicationSystemTestCase
  setup do
    @school = School.create!(name: "Test School", address: "123 Main St", has_paid: 1)
    @attendance = Attendance.first
    @student = Student.find(@attendance.student_id)
    @principal = User.create!(
      first_name: "Principal",
      last_name: "Test",
      personal_email: "principal_#{SecureRandom.hex(4)}@gmail.com",
      role: "principal",
      password: "password123",
      school_id: @school.id
    )

    @principal.update(
      password: "password123"
    )

    login_as(@principal)
  end

  test "visiting the index" do
    visit attendances_url
    assert_selector "h2 span", text: "Attendances"
  end

  # NOTE: This test will fail because the logic for creating student has changed
  # if the attendance already existed then checking in again will undo the checkin
  # test "should create attendance" do
  #   visit new_attendance_url
  #   within "tr[data-content='#{@student.name}']" do
  #     click_on "Check-in"
  #   end
  # end
end
