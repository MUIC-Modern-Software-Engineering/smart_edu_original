FactoryBot.define do
  factory :payment do
    association :user
    amount { 1000 }
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    status { "succeeded" }
    subscription_start { Time.zone.now }
    subscription_end { Time.zone.now + 1.year }
    stripe_payment_intent_id { "test_intent_123" }
  end
end
