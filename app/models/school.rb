# frozen_string_literal: true

# == Schema Information
#
# Table name: schools
#
#  id         :integer          not null, primary key
#  address    :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class School < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
end
