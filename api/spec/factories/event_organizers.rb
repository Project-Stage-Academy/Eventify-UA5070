FactoryBot.define do
  factory :event_organizer do
    association :event
    association :user
  end
end
