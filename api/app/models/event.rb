class Event < ApplicationRecord
  # belongs_to :organizer, class_name: "User", optional: false

  has_many :event_organizers, dependent: :destroy
  has_many :organizers, through: :event_organizers, source: :user

  enum :event_status, {
    draft: 0,
    published: 1,
    cancelled: 2,
    archived: 3
  }

  enum :review_status, {
    pending_review: 0,
    on_review: 1,
    unverified: 2,
    approved: 3,
    rejected: 4
  }

  # Validations for text fields
  validates :title, presence: true, length: { maximum: 128 }
  validates :description, length: { maximum: 500 }, allow_blank: true

  # Validations for required dates and location
  validates :location, :start_date, :finish_date, presence: true

  # Custom validation methods
  validate :validate_start_date
  validate :validate_finish_date

  # Validations for numeric fields
  validates :ticket_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: false
  validates :participant_capacity, numericality: { greater_than_or_equal_to: 0 }, allow_nil: false

  # Validations for organizer
  validate :validate_organizer_presence

  private

  def validate_start_date
    return if start_date.blank?

    if start_date < Time.current.utc
      errors.add(:start_date, :not_in_future)
    end
  end

  def validate_finish_date
    return if start_date.blank? || finish_date.blank?

    if finish_date < start_date
      errors.add(:finish_date, :after_start_date)
    end
  end

  def validate_organizer_presence
    return unless new_record? && event_organizers.empty?

    errors.add(:base, :missing_organizer)
  end
end
