# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  approved        :boolean          default(FALSE)
#  email_address   :string           not null
#  first_name      :string
#  is_active       :boolean          default(TRUE)
#  last_name       :string
#  password_digest :string           not null
#  personal_email  :string           not null
#  role            :string           default("student")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  school_id       :integer
#
# Indexes
#
#  index_users_on_email_address  (email_address) UNIQUE
#  index_users_on_school_id      (school_id)
#
# Foreign Keys
#
#  school_id  (school_id => schools.id)
#
class User < ApplicationRecord
  has_secure_password

  has_many :attendances, dependent: :destroy
  has_many :sessions, dependent: :destroy

  has_many :students, primary_key: :email_address, foreign_key: :student_email_address
  has_many :homerooms, foreign_key: :teacher_id, dependent: :destroy
  has_many :principal_teacher_relationships, foreign_key: :teacher_id, dependent: :destroy
  has_many :teacher_student_relationships, foreign_key: :teacher_id, dependent: :destroy

  before_validation :generate_school_email, on: :create

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :personal_email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8, maximum: 20 }, if: :password_required?
  validates :school_id, presence: true

  ROLES = { admin: "admin", principal: "principal", teacher: "teacher", student: "student", system: "system" }.freeze
  validates :role, inclusion: { in: ROLES.values }

  scope :approved, -> { where(approved: true) }
  scope :pending_in_school, ->(school_id) { where(approved: false, school_id: school_id) }

  before_create :auto_approve_principal

  def auto_approve_principal
    self.approved = true if principal? || student?
  end

  def can_manage_teachers?
    admin? || principal?
  end

  def admin?
    role == "admin"
  end

  def principal?
    role == "principal"
  end

  def teacher?
    role == "teacher"
  end

  def student?
    role == "student"
  end

  def system?
    role == "system"
  end

  private

  def generate_school_email
    return if email_address.present?
    return if first_name.blank? || last_name.blank?

    first_name_part = first_name.strip.downcase.gsub(/\s+/, "")
    last_name_part = last_name.strip.downcase.gsub(/\s+/, "")[0..2] # First 3 letters of last name
    school_domain = "#{role.downcase}.schoolname.edu"

    base_email = "#{first_name_part}.#{last_name_part}@#{school_domain}"
    unique_email = base_email
    counter = 1

    while User.exists?(email_address: unique_email)
      unique_email = "#{first_name_part}.#{last_name_part}#{counter}@#{school_domain}"
      counter += 1
    end

    self.email_address = unique_email
  end


  def password_required?
    new_record? || password.present?
  end

  def validate_student_email
    unless Student.exists?(student_email_address: email_address)
      errors.add(:email_address, "is not linked to any student in our records")
    end
  end
end
