FactoryBot.define do
  factory :category_tag do
    association :category
    association :tag
  end
end 