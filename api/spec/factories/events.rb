FactoryBot.define do
  factory :event do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    location { Faker::Address.city }
    start_date { 2.days.from_now }
    finish_date { 3.days.from_now }
    ticket_price { 10.0 }
    participant_capacity { 100 }
    status { :draft }
  end
end
