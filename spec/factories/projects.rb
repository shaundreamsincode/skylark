FactoryBot.define do
  factory :project do
    title { Faker::Company.catch_phrase }
    summary { Faker::Lorem.sentence(word_count: 10) }
    description { Faker::Lorem.paragraph(sentence_count: 3) }
    visibility { 0 } # public
    association :user

    trait :private do
      visibility { 1 }
    end

    trait :with_organization do
      association :organization
    end

    trait :with_long_description do
      description { Faker::Lorem.paragraph(sentence_count: 5) }
    end
  end
end 