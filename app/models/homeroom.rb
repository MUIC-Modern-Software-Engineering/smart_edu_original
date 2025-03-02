# frozen_string_literal: true

# == Schema Information
#
# Table name: homerooms
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  classroom_id :integer          not null
#  teacher_id   :integer          not null
#
# Indexes
#
#  index_homerooms_on_classroom_id  (classroom_id)
#  index_homerooms_on_teacher_id    (teacher_id)
#
# Foreign Keys
#
#  classroom_id  (classroom_id => classrooms.id)
#  teacher_id    (teacher_id => users.id)
#
class Homeroom < ApplicationRecord
  validates :teacher_id, presence: true
  validates :classroom_id, presence: true
end
