class CheckinService
  def self.checkin(student, user)
    Attendance.create(student: student, timestamp: Time.zone.now, user: user)
  end
end
