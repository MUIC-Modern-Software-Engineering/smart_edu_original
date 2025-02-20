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
#
class Student < ApplicationRecord
  validates :name, presence: true, length: { minimum: 4, maximum: 20 }
  validates :grade, presence: true
  validates :classroom_id, presence: true
  validates :student_email_address, presence: true
  validates :parent_email_address, presence: true
  include Discard::Model
  before_save :set_default_uid
  scope :active, -> { where(is_active: true) }

  private

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def set_default_uid
    self.uid = SecureRandom.uuid if uid.blank?
  end
end
