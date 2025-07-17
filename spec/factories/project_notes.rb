FactoryBot.define do
  factory :project_note do
    association :project
    association :user
    entry_type { :report }
    title { Faker::Lorem.sentence(word_count: 3) }
    content { Faker::Lorem.paragraph(sentence_count: 2) }
  end
end 