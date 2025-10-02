require "rails_helper"

RSpec.describe LogEntry, type: :model do
  describe "validations" do
    subject { described_class.new(user_id: 1, event_id: 1, action: :event_member_created) }

    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:event_id) }
    it { should validate_presence_of(:action) }
  end
end
