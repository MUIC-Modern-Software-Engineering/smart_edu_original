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
#  subscription_end         :datetime
#  subscription_start       :datetime
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
require "test_helper"

class PaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
