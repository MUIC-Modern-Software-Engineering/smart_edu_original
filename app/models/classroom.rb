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
#  school_id   :integer
#
# Indexes
#
#  index_classrooms_on_school_id_and_class_id  (school_id,class_id) UNIQUE
#
class Classroom < ApplicationRecord
  belongs_to :school
  validates :class_id, presence: true
  validates :grade_level, presence: true
  validates :school_id, presence: true
  validates :class_id, uniqueness: { scope: :school_id, message: "Class ID must be unique within the school" }

  has_many :students
end
