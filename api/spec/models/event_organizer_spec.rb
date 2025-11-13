require 'rails_helper'

RSpec.describe EventOrganizer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:event) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:event_id) }

  it 'validates uniqueness of user per event' do
    user = create(:user)
    event = create(:event, organizer_user: user)

    duplicate = build(:event_organizer, event: event, user: user)

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:user_id]).to include("is already an organizer for this event")
  end
end
