class AttendanceMailer < ApplicationMailer
  def check_in_notification(student, attendance)
    @student = student
    @attendance = attendance

    @user = User.find_by(email_address: @student.student_email_address)

    mail(
      to: @student.parent_email_address,
      subject: "Check-In Notification"
    )
  end
end
