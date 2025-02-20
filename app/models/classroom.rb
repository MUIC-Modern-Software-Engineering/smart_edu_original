# frozen_string_literal: true

# == Schema Information
#
# Table name: classrooms
#
#  id          :integer          not null, primary key
#  grade_level :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  class_id    :string           not null
#
# Indexes
#
#  index_classrooms_on_class_id  (class_id) UNIQUE
#
class Classroom < ApplicationRecord
  validates :class_id, presence: true
  validates :grade_level, presence: true
end
