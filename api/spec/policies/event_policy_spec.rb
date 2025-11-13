require 'rails_helper'

RSpec.describe EventPolicy, type: :policy do
  let!(:user_role)  { create(:role, :user) }
  let!(:admin_role) { create(:role, :admin) }

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin) { create(:user) }
  let(:event) { create(:event) }

  before do
    admin.add_role!(admin_role.name)
    user.add_role!(user_role.name)
    other_user.add_role!(user_role.name)
  end

  describe '#update?' do
    it 'allows admin to update any event' do
      expect(EventPolicy.new(admin, event).update?).to be_truthy
    end

    it 'allows organizer to update their event' do
      EventOrganizer.create!(event: event, user: user)
      expect(EventPolicy.new(user, event).update?).to be_truthy
    end

    it 'denies non-organizer to update event' do
      expect(EventPolicy.new(other_user, event).update?).to be_falsey
    end
  end

  describe '#destroy?' do
    it 'allows admin to destroy any event' do
      expect(EventPolicy.new(admin, event).destroy?).to be_truthy
    end

    it 'allows primary organizer to destroy event' do
      EventOrganizer.create!(event: event, user: user, is_primary: true)
      expect(EventPolicy.new(user, event).destroy?).to be_truthy
    end

    it 'denies non-primary organizer to destroy event' do
      EventOrganizer.create!(event: event, user: user, is_primary: false)
      expect(EventPolicy.new(user, event).destroy?).to be_falsey
    end

    it 'denies non-organizer to destroy event' do
      expect(EventPolicy.new(other_user, event).destroy?).to be_falsey
    end
  end

  describe '#manage_organizers?' do
    it 'allows admin to manage organizers' do
      expect(EventPolicy.new(admin, event).manage_organizers?).to be_truthy
    end

    it 'allows primary organizer to manage organizers' do
      EventOrganizer.create!(event: event, user: user, is_primary: true)
      expect(EventPolicy.new(user, event).manage_organizers?).to be_truthy
    end

    it 'denies non-primary organizer to manage organizers' do
      EventOrganizer.create!(event: event, user: user, is_primary: false)
      expect(EventPolicy.new(user, event).manage_organizers?).to be_falsey
    end

    it 'denies non-organizer to manage organizers' do
      expect(EventPolicy.new(other_user, event).manage_organizers?).to be_falsey
    end
  end
end
