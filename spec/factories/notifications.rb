FactoryBot.define do
  factory :notification do
    association :user
    association :notifiable, factory: :project
    message { Faker::Lorem.sentence(word_count: 5) }
    read { false }
  end
end 