FactoryBot.define do
  factory :event_member do
    event
    user
    sequence(:ticket_qr_code) { |n| "QR%0#{EventMember::QR_CODE_LENGTH - 2}d" % n }
  end
end
