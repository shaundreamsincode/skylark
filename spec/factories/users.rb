FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    bio { Faker::Lorem.paragraph(sentence_count: 2) }
    super_admin { false }

    trait :super_admin do
      super_admin { true }
    end

    trait :with_bio do
      bio { Faker::Lorem.paragraph(sentence_count: 3) }
    end
  end
end 