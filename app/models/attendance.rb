# == Schema Information
#
# Table name: attendances
#
#  id         :integer          not null, primary key
#  timestamp  :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  student_id :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_attendances_on_student_id  (student_id)
#  index_attendances_on_user_id     (user_id)
#
# Foreign Keys
#
#  student_id  (student_id => students.id)
#  user_id     (user_id => users.id)
#
class Attendance < ApplicationRecord
  belongs_to :student
  belongs_to :user
end

def checkin
  uid = params[:uid]

  student = Student.find_by(uid: uid)
  if student
    Attendance.create(student: student, timestamp: Time.current, user: current_user)
    flash[:notice] = "Student checked in successfully at #{Time.current.strftime('%H:%M:%S')}."
  else
    flash[:alert] = "Student not found."
  end
  redirect_to admin_scan_qr_path
end
