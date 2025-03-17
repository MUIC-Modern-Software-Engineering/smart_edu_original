# == Schema Information
#
# Table name: payments
#
#  id                       :integer          not null, primary key
#  amount                   :integer          not null
#  email                    :string
#  first_name               :string
#  last_name                :string
#  status                   :string           default("pending"), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  stripe_payment_intent_id :string           not null
#  user_id                  :integer          not null
#
# Indexes
#
#  index_payments_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Payment < ApplicationRecord
  belongs_to :user

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :stripe_payment_intent_id, presence: true
  validates :status, inclusion: { in: %w[pending requires_payment_method requires_confirmation succeeded failed] }
  validates :first_name, presence: true
  validates :last_name, presence: true
end
