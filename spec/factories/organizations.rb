FactoryBot.define do
  factory :organization do
    name { Faker::Company.unique.name }

    trait :with_members do
      after(:create) do |organization|
        create_list(:organization_membership, 3, organization: organization)
      end
    end
  end
end 