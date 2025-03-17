class HomeController < ApplicationController
  def index
    @total_students = Student.count
    @attendance_count = Attendance.count
    @last_checkin = Attendance.maximum(:timestamp)
  end
end
