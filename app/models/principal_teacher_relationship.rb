# frozen_string_literal: true

# == Schema Information
#
# Table name: principal_teacher_relationships
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  principal_id :integer          not null
#  teacher_id   :integer          not null
#
# Indexes
#
#  index_principal_teacher_relationships_on_principal_id  (principal_id)
#  index_principal_teacher_relationships_on_teacher_id    (teacher_id)
#
# Foreign Keys
#
#  principal_id  (principal_id => users.id)
#  teacher_id    (teacher_id => users.id)
#
class PrincipalTeacherRelationship < ApplicationRecord
  validates :principal_id, presence: true
  validates :teacher_id, presence: true

  belongs_to :principal, class_name: "User"
  belongs_to :teacher, class_name: "User"

  validates :teacher_id, uniqueness: { scope: :principal_id, message: "This teacher is already assigned to the principal." }
end
