FactoryBot.define do
  factory :event do
    title { "Test Event" }
    location { "Kyiv" }
    start_date { 1.day.from_now }
    finish_date { 2.days.from_now }
    participant_capacity { 10 }
    ticket_price { 100 }

    transient do
      organizer_user { nil }
    end

    after(:create) do |event, evaluator|
      if evaluator.organizer_user
        FactoryBot.create(:event_organizer, event: event, user: evaluator.organizer_user, is_primary: true)
      else
        FactoryBot.create(:event_organizer, event: event, user: FactoryBot.create(:user), is_primary: true)
      end
    end
  end
end
