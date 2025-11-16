class AutoEventApproveJob < ApplicationJob
  queue_as :default

  DELAY = 24.hours

  def self.after_delay(event)
    job = set(wait: DELAY).perform_later(event.id)

    unless event.update(approve_job_id: job.provider_job_id)
      Rails.logger.error("Failed to save approve_job_id for Event #{event.id}: #{event.errors.full_messages.join(', ')}")
    end

    job
  end

  def perform(event_id)
    event = Event.find(event_id)

    approve(event)

  rescue StandardError => e
    log_error(event, e.message)
    raise
  end

  private

  def approve(event)
    new_status = EventStatusService.new(event).status_on_auto_approve

    log_error(event, "Invalid status transition from #{event.status}") if new_status.nil?

    log_error(event, event.errors.full_messages.join(", ")) unless event.update(status: new_status)
  end

  def log_error(event, message)
    Rails.logger.error("AutoEventApproveJob: Event ID #{event.id}: #{message}")
  end
end
