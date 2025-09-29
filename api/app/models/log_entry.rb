class LogEntry
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include MongoidEnum

  field :user_id, type: Integer
  field :event_id, type: Integer
  field :metadata, type: Hash
  mongoid_enum :action, %i[
    event_member_created
    event_member_deleted
    event_organizer_created
    event_organizer_deleted
    event_created
    event_updated
    event_published
    event_canceled
    event_archived
    event_approved
    event_rejected
  ]

  validates :user_id, :event_id, :action, presence: true

  index({ user_id: 1, event_id: 1, action: 1, created_at: -1 })
  index({ event_id: 1, action: 1, created_at: -1 })
end
