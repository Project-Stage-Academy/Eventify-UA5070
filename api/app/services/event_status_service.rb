class EventStatusService
  INITIAL_STATUS = :draft

  def initialize(event)
    @event = event
  end

  def status_on_update(hard_changed)
    new_status = STATUS_ON_UPDATE.fetch(event.status.to_sym, nil)
    new_status = new_status.respond_to?(:call) ? new_status.call(hard_changed) : new_status

    new_status
  end

  def status_on_publish
    STATUS_ON_PUBLISH.fetch(@event.status.to_sym, nil)
  end

  def status_on_archive
    STATUS_ON_ARCHIVE.fetch(@event.status.to_sym, nil)
  end

  def status_on_cancel
    STATUS_ON_CANCEL.fetch(@event.status.to_sym, nil)
  end

  def status_on_auto_approve
    STATUS_ON_AUTO_APPROVE.fetch(@event.status.to_sym, nil)
  end

  COPY_TITLE_PREFIX = "Copy of: ".freeze
  def generate_copy_title
    @event.title = "#{COPY_TITLE_PREFIX}#{@event.title}".truncate(MAX_TITLE_LENGTH)
  end

  def schedule_auto_approve_if_needed(new_status)
    AutoEventApproveJob.after_delay(@event) if STATUS_ON_AUTO_APPROVE.has_key?(new_status)
  end

  def cancel_approve_job_if_needed(old_status)
    return if @event.approve_job_id.blank? || STATUS_ON_AUTO_APPROVE.has_key?(old_status)

    SolidQueue::Job.find_by(id: @event.approve_job_id)&.discard
    @event.update_column(:approve_job_id, nil)
  rescue StandardError => e
    Rails.logger.error("Failed to cancel approve job #{@event.approve_job_id} for Event #{@event.id}: #{e.message}")
  end

  def update_status(new_status)
    raise Api::Errors::EventError::InvalidStatusTransition.new() if new_status.nil?

    old_status = @event.status.to_sym

    if @event.update(status: new_status)
      cancel_approve_job_if_needed(old_status)
      schedule_auto_approve_if_needed(new_status)

      return true
    end

    false
  end

  private

  STATUS_ON_UPDATE = {
    draft: :draft,
    rejected: :draft,
    published_unverified: :published_unverified,
    published_rejected: :published_rejected,
    published_on_review: :published_on_review,
    published: ->(hard_changed) { hard_changed ? :published_on_review : :published }
  }.freeze

  STATUS_ON_PUBLISH = {
    draft: :draft_on_review,
    published_rejected: :published_on_review
  }.freeze

  STATUS_ON_ARCHIVE = {
    published: :archived,
    published_unverified: :archived,
    published_rejected: :archived,
    published_on_review: :archived
  }.freeze

  STATUS_ON_CANCEL = {
    draft_on_review: :draft,
    published: :cancelled,
    published_unverified: :cancelled,
    published_rejected: :cancelled,
    published_on_review: :cancelled
  }.freeze

  STATUS_ON_AUTO_APPROVE = {
    draft_on_review: :published_unverified,
    published_on_review: :published_unverified
  }.freeze
end
