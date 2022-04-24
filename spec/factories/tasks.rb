FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "title#{n}" }
    sequence(:sort_number) { |n| n }

    association :group
    association :status

    trait :status_before_start do
      status_id { 1 }
    end

    trait :status_working do
      status_id { 2 }
    end

    trait :status_finish do
      status_id { 3 }
    end
  end
end
