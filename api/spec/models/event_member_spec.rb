require 'rails_helper'

RSpec.describe EventMember, type: :model do
  describe "validations" do
    subject do
      described_class.new(
        event: Event.new(
          title: "Test",
          location: "Kyiv",
          start_date: 2.days.from_now,
          finish_date: 3.days.from_now,
          participant_capacity: 100
        ),
        user: User.new(name: "J", email: "j@example.com", password: "password123"),
        ticket_qr_code: "ABCDEF1234"
      )
    end

    it { is_expected.to validate_presence_of(:event) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:ticket_qr_code) }

    it { is_expected.to validate_uniqueness_of(:ticket_qr_code) }

    it { is_expected.to validate_length_of(:ticket_qr_code).is_equal_to(10) }
    it { is_expected.to validate_length_of(:comment).is_at_most(1000) }

    it { is_expected.to allow_value(nil).for(:rating) }
    it { is_expected.to allow_value(nil).for(:comment) }
    it { is_expected.to allow_value("").for(:comment) }

    it { is_expected.to validate_numericality_of(:rating).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(5) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:event) }
    it { is_expected.to belong_to(:user) }
  end
end
