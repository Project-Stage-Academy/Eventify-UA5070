FactoryBot.define do
  factory :event_member do
    event
    user
    sequence(:ticket_qr_code) { |n| "QR%08d" % n }
  end
end
