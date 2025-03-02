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
  belongs_to :user, primary_key: :email_address, foreign_key: :student_email_address
  belongs_to :classroom

  validates :grade, presence: true
  validates :classroom_id, presence: true
  validates :student_email_address, presence: true, uniqueness: true
  validates :parent_email_address, presence: true

  include Discard::Model
  before_save :set_full_name, unless: -> { name.present? } # ✅ Ensure name is set before saving
  before_save :set_default_uid

  scope :active, -> { where(is_active: true) }

  private

  def set_full_name
    user = User.find_by(email_address: self.student_email_address)
    self.name = "#{user.first_name} #{user.last_name}" if user
  end

  def set_default_uid
    self.uid = SecureRandom.uuid if uid.blank?
  end

def self.ransackable_attributes(auth_object = nil)
  auth_object
  [ "classroom_id", "discarded_at", "grade", "id", "is_active", "name", "parent_email_address", "student_email_address", "uid" ]
end
end
