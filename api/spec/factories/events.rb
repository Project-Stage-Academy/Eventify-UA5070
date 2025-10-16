FactoryBot.define do
  factory :event do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.sentence(word_count: 10) }
    location { Faker::Address.full_address }
    coordinates { "POINT(#{Faker::Address.latitude}, #{Faker::Address.longitude})" }
    start_date { 2.days.from_now }
    finish_date { 3.days.from_now }
    ticket_price { Faker::Commerce.price(range: 0..100.0) }
    participant_capacity { Faker::Number.between(from: 10, to: 1000) }
    status { :draft }
  end
end
