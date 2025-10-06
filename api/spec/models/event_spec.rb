require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "enums" do
    it { should define_enum_for(:status).with_values(
      draft: 0,
      draft_on_review: 1,
      published: 2,
      rejected: 3,
      published_unverified: 4,
      published_on_review: 5,
      published_rejected: 6,
      archived: 7,
      cancelled: 8
      ) }
  end

  describe "validations" do
    subject(:event) { build(:event) }

    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(128) }
    it { should validate_length_of(:description).is_at_most(500) }
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:finish_date) }
    it { should validate_numericality_of(:ticket_price).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:participant_capacity).is_greater_than_or_equal_to(0) }

    context "custom date validations" do
      it "is invalid if start_date is in the past" do
        event = build(
          :event,
          start_date: 1.day.ago,
          finish_date: 2.days.from_now
        )

        expect(event).not_to be_valid
        expect(event.errors[:start_date]).to include("The event's start date must be in the future")
      end

      it "is invalid if finish_date is before start_date" do
        event = build(
          :event,
          start_date: 2.days.from_now,
          finish_date: 1.day.from_now
        )

        expect(event).not_to be_valid
        expect(event.errors[:finish_date]).to include("The event's finish date must be after its start date")
      end

      it "is valid if start_date is in future and finish_date is after start_date" do
        event = build(
          :event,
          start_date: 2.days.from_now,
          finish_date: 3.days.from_now
        )

        expect(event).to be_valid
      end
    end
  end
end
