FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "title#{n}" }
    sequence(:sort_number) { |n| n }

    association :group
    association :status

    trait :status_before_start do
      status { Status.find_or_create_by(name: 'before_start') }
    end

    trait :status_working do
      status { Status.find_or_create_by(name: 'working') }
    end

    trait :status_finish do
      status { Status.find_or_create_by(name: 'finish') }
    end
  end
end
