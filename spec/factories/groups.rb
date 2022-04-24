FactoryBot.define do
  factory :group do
    sequence(:name) { |n| "name#{n}" }
    sequence(:team_id) { |n| n }
  end
end
