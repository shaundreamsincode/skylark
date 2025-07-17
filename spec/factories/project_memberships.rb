FactoryBot.define do
  factory :project_membership do
    association :project
    association :user
    status { 0 } # pending
    request_message { Faker::Lorem.sentence }

    trait :approved do
      status { 1 }
    end

    trait :rejected do
      status { 2 }
    end
  end
end 