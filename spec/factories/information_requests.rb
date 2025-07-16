FactoryBot.define do
  factory :information_request do
    association :project
    association :user
    title { Faker::Lorem.sentence(word_count: 4) }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    expires_at { 1.week.from_now }
  end
end 