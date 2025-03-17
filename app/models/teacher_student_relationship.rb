# frozen_string_literal: true

# == Schema Information
#
# Table name: teacher_student_relationships
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  student_id :integer          not null
#  teacher_id :integer          not null
#
# Indexes
#
#  index_teacher_student_relationships_on_student_id  (student_id)
#  index_teacher_student_relationships_on_teacher_id  (teacher_id)
#
# Foreign Keys
#
#  student_id  (student_id => users.id)
#  teacher_id  (teacher_id => users.id)
#
class TeacherStudentRelationship < ApplicationRecord
  validates :teacher_id, presence: true
  validates :student_id, presence: true
end
