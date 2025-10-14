require 'rails_helper'

RSpec.describe EventMember, type: :model do
  describe "validations" do
    subject { FactoryBot.create(:event_member) }

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

    it "validates presence of rating if comment is present" do
      subject.comment = "Great event!"
      subject.rating = nil
      expect(subject).not_to be_valid
      expect(subject.errors.details[:rating]).to include(error: :required_if_comment_present)

      subject.rating = 4
      expect(subject).to be_valid
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:event) }
    it { is_expected.to belong_to(:user) }
  end
end
