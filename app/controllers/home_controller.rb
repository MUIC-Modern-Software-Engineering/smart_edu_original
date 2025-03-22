class HomeController < ApplicationController
  def index
    if current_user.school_id.nil?
      redirect_to root_path, alert: "You are not associated with any school."
      return
    end

    school_classrooms = Classroom.where(school_id: current_user.school_id).pluck(:id)

    # Total Students
    @total_students = Student.where(classroom_id: school_classrooms).count
    @active_students = Student.where(is_active: true, classroom_id: school_classrooms).count
    @inactive_students = @total_students - @active_students

    # Total Teachers
    @total_teachers = User.where(role: "teacher", school_id: current_user.school_id, approved: true).count

    # Checkins
    @last_checkin = Attendance.joins(:student)
                              .where(students: { classroom_id: school_classrooms })
                              .maximum(:timestamp)
    @checkins_today = Attendance.joins(:student)
                                .where(students: { classroom_id: school_classrooms })
                                .where("attendances.timestamp >= ?", Time.zone.now.beginning_of_day)
                                .count
    @checkins_this_month = Attendance.joins(:student)
                                     .where(students: { classroom_id: school_classrooms })
                                     .where("attendances.timestamp >= ?", Time.zone.now.beginning_of_month)
                                     .count

    # Attendance
    @attendance_count = Attendance.joins(:student)
                                  .where(students: { classroom_id: school_classrooms })
                                  .count
    @attendance_rate = @active_students.zero? ? 0 : ((@attendance_count.to_f / @active_students) * 100).round(1)
    @attendance_rate_today = @active_students.zero? ? 0 :
                               ((@checkins_today.to_f / @active_students) * 100).round(1)
    @attendance_rate_month = @active_students.zero? ? 0 :
                               ((@checkins_this_month.to_f / @active_students) * 100).round(1)
  end
end
