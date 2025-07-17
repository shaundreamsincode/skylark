FactoryBot.define do
  factory :information_request do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    expires_at { 1.week.from_now }
    token { SecureRandom.hex(10) }
    association :project
    association :user
  end
end 