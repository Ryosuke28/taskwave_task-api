FactoryBot.define do
  factory :status do
    sequence(:name) { |n| "status#{n}" }

    trait :before_start do
      id { 1 }
      name { 'before_start' }
      description { '着手前' }
    end

    trait :working do
      id { 2 }
      name { 'working' }
      description { '作業中' }
    end

    trait :finish do
      id { 3 }
      name { 'finish' }
      description { '完了' }
    end
  end
end
