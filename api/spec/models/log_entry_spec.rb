require "rails_helper"

RSpec.describe LogEntry, type: :model do
  let(:log_entry) { described_class.new(user_id: 1, event_id: 1, action: :event_member_created) }
  let(:actions) { %i[event_member_created event_organizer_created] }

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

      actions.each do |valid_action|
        log_entry.action = valid_action
        expect(log_entry).to be_valid
      end
    end

    it "provides a class method to list all actions" do
      expect(described_class.actions).to match_array(actions.map(&:to_s))
    end

    it "provides scopes for each action" do
      log_entry.update!(action: actions.second)

      actions.each do |action|
        scope = described_class.send("action_#{action}")

        expect(scope).not_to include(log_entry)

        log_entry.update!(action: action)
        expect(scope).to include(log_entry)
      end
    end

    it "provides setter methods for each action" do
      actions.each do |action|
        log_entry.send("action_#{action}!")
        expect(log_entry.action).to eq(action.to_s)
      end
    end

    it "provides predicate methods for each action" do
      actions.each do |action|
        expect(log_entry.send("action_#{action}?")).to eq(log_entry.action == action.to_s)
      end
    end
  end
end
