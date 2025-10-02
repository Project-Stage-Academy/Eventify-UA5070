class LogEntryCreationJob < ApplicationJob
  queue_as :default

  def perform(user_id:, event_id:, action:, metadata:)
    LogEntry.create!(
      user_id: user_id,
      event_id: event_id,
      action: action,
      metadata: metadata
    )
  end
end
