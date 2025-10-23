FactoryBot.define do
  factory :role do
    name { "user" }

    trait :user do
      name { "user" }
    end

    trait :admin do
      name { "admin" }
    end

    trait :organizer do
      name { "organizer" }
    end
  end
end
