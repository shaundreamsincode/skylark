FactoryBot.define do
  factory :category do
    name { Faker::Lorem.unique.word }
    description { Faker::Lorem.sentence(word_count: 5) }
  end
end 