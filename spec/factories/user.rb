FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    personal_email { Faker::Internet.email }
    email_address { Faker::Internet.email }
    password { "password123" }
    role { "student" }
    association :school
  end
end
