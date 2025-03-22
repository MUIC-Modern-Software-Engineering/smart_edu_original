# == Schema Information
#
# Table name: schools
#
#  id         :integer          not null, primary key
#  address    :string           not null
#  has_paid   :boolean          default(FALSE)
#  name       :string           not null
#  tier       :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_schools_on_name  (name) UNIQUE
#
FactoryBot.define do
  factory :school do
    name { Faker::University.name }
    sequence(:id) { |n| n }
    has_paid { 1 }
    address { Faker::Address.full_address }
  end
end
