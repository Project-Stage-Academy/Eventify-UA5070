class LogEntryCreationJob < ApplicationJob
  queue_as :default

  def perform(user_id:, event_id:, action:, metadata:)
    LogEntry.create!(
      user_id: user_id,
      event_id: event_id,
      action: action,
      metadata: metadata
    )

  rescue => e
    Rails.logger.error("LogEntryCreationJob failed: #{e.message}")
    raise
  end
end
