# frozen_string_literal: true

# == Schema Information
#
# Table name: school_tiers
#
#  id         :integer          not null, primary key
#  tier       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  school_id  :integer          not null
#
# Indexes
#
#  index_school_tiers_on_school_id  (school_id)
#
# Foreign Keys
#
#  school_id  (school_id => schools.id)
#
class SchoolTier < ApplicationRecord
  validates :school_id, presence: true
  validates :tier, presence: true
end
