FactoryBot.define do
  factory :role do
    name { Role.value(:user) }

    trait :admin do
      name { Role.value(:admin) }
    end
  end
end
