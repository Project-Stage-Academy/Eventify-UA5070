FactoryBot.define do
  factory :event do
    sequence(:title) { |n| "Test Event #{n}" }
    description { "Default event description" }
    location { "Kyiv" }
    coordinates { "POINT(30.5238 50.4547)" }
    start_date { 2.days.from_now }
    finish_date { 3.days.from_now }
    ticket_price { 50.0 }
    participant_capacity { 30 }
    status { :draft }

    transient do
      organizer_user { nil }
    end

    after(:create) do |event, evaluator|
      user = evaluator.organizer_user || FactoryBot.create(:user)
      FactoryBot.create(:event_organizer, event: event, user: user, is_primary: true)
    end
  end
end
