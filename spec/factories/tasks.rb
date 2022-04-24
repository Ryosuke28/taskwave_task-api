FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "title#{n}" }
    sequence(:sort_number) { |n| n }

    association :group
    association :status
  end
end
