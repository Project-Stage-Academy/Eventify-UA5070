require "rails_helper"

RSpec.describe LogEntry, type: :model do
  let(:log_entry) { described_class.new(user_id: 1, event_id: 1, action: :event_member_created) }

  describe "validations" do
    subject { log_entry }

    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:event_id) }
    it { should validate_presence_of(:action) }
  end

  describe "actions enum (MongoidEnum)" do
    it "validates inclusion in defined actions" do
      log_entry.action = :undefined_action
      expect(log_entry).not_to be_valid
    end
  end
end
