FactoryBot.define do
  factory :information_request_response do
    association :information_request
    content { Faker::Lorem.paragraph(sentence_count: 3) }
  end
end 