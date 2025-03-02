# == Schema Information
#
# Table name: students
#
#  id                    :integer          not null, primary key
#  discarded_at          :datetime
#  grade                 :integer
#  is_active             :boolean          default(TRUE), not null
#  name                  :string
#  parent_email_address  :string           default("parent@example.com"), not null
#  student_email_address :string           default("student@example.com"), not null
#  uid                   :string           not null
#  classroom_id          :integer          default(0), not null
#
# Indexes
#
#  index_students_on_classroom_id  (classroom_id)
#  index_students_on_discarded_at  (discarded_at)
#
# Foreign Keys
#
#  classroom_id           (classroom_id => classrooms.id)
#  student_email_address  (student_email_address => users.email_address)
#  student_email_address  (student_email_address => users.email_address)
#
require "test_helper"

class StudentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
