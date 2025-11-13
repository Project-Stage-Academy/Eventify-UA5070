FactoryBot.define do
  factory :event_organizer do
    association :event
    association :user
    is_primary { false }
  end
end
