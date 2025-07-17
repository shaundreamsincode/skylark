FactoryBot.define do
  factory :organization_membership do
    association :organization
    association :user
    role { 0 }
  end
end 