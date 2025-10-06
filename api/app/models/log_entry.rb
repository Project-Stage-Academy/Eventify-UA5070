class LogEntry
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include MongoidEnum

  field :user_id, type: Integer
  field :event_id, type: Integer
  field :metadata, type: Hash
  mongoid_enum :action, %i[
    event_member_created
    event_organizer_created
  ]

  validates :user_id, presence: true
  validates :event_id, presence: true
  validates :action, presence: true

  index({ user_id: 1, event_id: 1, action: 1, created_at: -1 })
  index({ event_id: 1, action: 1, created_at: -1 })
end
