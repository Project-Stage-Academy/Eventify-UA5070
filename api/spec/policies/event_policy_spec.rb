require 'rails_helper'

RSpec.describe EventPolicy, type: :policy do
  let(:user) { create(:user) }              # звичайний користувач
  let(:other_user) { create(:user) }        # інший користувач
  let(:admin) { create(:user) }             # адміністратор
  let(:event) { create(:event) }            # тестова подія

  before do
    admin.add_role!(:admin)
  end

  describe '#update?' do
    it 'allows admin to update any event' do
      expect(EventPolicy.new(admin, event).update?).to eq(true)
    end

    it 'allows organizer to update their event' do
      EventOrganizer.create!(event: event, user: user)
      expect(EventPolicy.new(user, event).update?).to eq(true)
    end

    it 'denies non-organizer to update event' do
      expect(EventPolicy.new(other_user, event).update?).to eq(false)
    end
  end

  describe '#destroy?' do
    it 'allows admin to destroy any event' do
      expect(EventPolicy.new(admin, event).destroy?).to eq(true)
    end

    it 'allows primary organizer to destroy event' do
      EventOrganizer.create!(event: event, user: user, is_primary: true)
      expect(EventPolicy.new(user, event).destroy?).to eq(true)
    end

    it 'denies non-primary organizer to destroy event' do
      EventOrganizer.create!(event: event, user: user, is_primary: false)
      expect(EventPolicy.new(user, event).destroy?).to eq(false)
    end

    it 'denies non-organizer to destroy event' do
      expect(EventPolicy.new(other_user, event).destroy?).to eq(false)
    end
  end

  describe '#manage_organizers?' do
    it 'allows admin to manage organizers' do
      expect(EventPolicy.new(admin, event).manage_organizers?).to eq(true)
    end

    it 'allows primary organizer to manage organizers' do
      EventOrganizer.create!(event: event, user: user, is_primary: true)
      expect(EventPolicy.new(user, event).manage_organizers?).to eq(true)
    end

    it 'denies non-primary organizer to manage organizers' do
      EventOrganizer.create!(event: event, user: user, is_primary: false)
      expect(EventPolicy.new(user, event).manage_organizers?).to eq(false)
    end

    it 'denies non-organizer to manage organizers' do
      expect(EventPolicy.new(other_user, event).manage_organizers?).to eq(false)
    end
  end
end
