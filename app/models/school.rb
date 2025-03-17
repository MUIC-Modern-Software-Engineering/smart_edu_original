# frozen_string_literal: true

# == Schema Information
#
# Table name: schools
#
#  id         :integer          not null, primary key
#  address    :string           not null
#  has_paid   :boolean          default(FALSE)
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_schools_on_name  (name) UNIQUE
#
class School < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :address, presence: true
end
