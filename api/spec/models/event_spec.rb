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
    it { should validate_numericality_of(:average_rating).is_in(1..5).allow_nil }
    it { should validate_numericality_of(:rating_count).is_greater_than_or_equal_to(0) }

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

  describe "associations" do
    it { is_expected.to have_many(:event_members) }
    it { is_expected.to have_many(:members).through(:event_members) }
  end

  describe '#joinable?' do
    let(:non_joinable_statuses) { described_class.statuses.keys.map(&:to_sym) - described_class::JOINABLE }

    it 'returns true for joinable statuses' do
      described_class::JOINABLE.each do |status|
        expect(build(:event, status:)).to be_joinable
      end
    end

    it 'returns false for non-joinable statuses' do
      non_joinable_statuses.each do |status|
        expect(build(:event, status:)).not_to be_joinable
      end
    end
  end

  describe "#available_tickets" do
    let(:capacity) { 50 }
    let(:booked) { 20 }
    let(:event) { build(:event, participant_capacity: capacity) }

    before do
      create_list(:event_member, booked, event: event)
    end

    it "calculates available tickets correctly" do
      expect(event.available_tickets).to eq(capacity - booked)
    end
  end

  describe "#update_rating_fields" do
    let(:event) { create(:event) }
    let(:rating) { 4 }
    let(:below_min_count) { Event::MIN_RATING_COUNT_FOR_AVERAGE - 1 }

    before { create_list(:event_member, below_min_count, event:, rating: rating) }

    it "updates rating_count correctly" do
      expect { event.update_rating_fields }.to change { event.rating_count }.to(below_min_count)
    end

    context "when rating_count is below MIN_RATING_COUNT_FOR_AVERAGE" do
      it "sets average_rating to nil" do
        event.update_rating_fields
        expect(event.average_rating).to be_nil
      end
    end

    context "when rating_count is equal or greater than MIN_RATING_COUNT_FOR_AVERAGE" do
      before { create(:event_member, event:, rating:) }

      it "calculates average_rating correctly" do
        expect { event.update_rating_fields }.to change { event.average_rating }.to(rating)
      end
    end
  end
end
