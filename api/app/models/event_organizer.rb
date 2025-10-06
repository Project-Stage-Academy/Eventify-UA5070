class EventOrganizer < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :user_id, presence: true
  validates :event_id, presence: true
  validates :user_id, uniqueness: { scope: :event_id }

  before_destroy :validate_last_organizer_removal

  private

  def validate_last_organizer_removal
    if event.event_organizers.reload.count <= 1
      errors.add(:base, :last_organizer_removal_forbidden)
      throw(:abort)
    end
  end
end
