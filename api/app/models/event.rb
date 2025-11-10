class Event < ApplicationRecord
  # belongs_to :organizer, class_name: "User", optional: false
  has_many :event_members, dependent: :destroy
  has_many :members, through: :event_members, source: :user

  has_many :event_organizers, dependent: :destroy
  has_many :organizers, through: :event_organizers, source: :user

  enum :status, {
    draft: 0,
    draft_on_review: 1,
    published: 2,
    rejected: 3,
    published_unverified: 4,
    published_on_review: 5,
    published_rejected: 6,
    archived: 7,
    cancelled: 8
  }

  JOINABLE = [
    :published,
    :published_unverified,
    :published_on_review,
    :published_rejected
  ].freeze

  # Validations for text fields
  validates :title, presence: true, length: { maximum: 128 }, uniqueness: true
  validates :description, length: { maximum: 500 }, allow_blank: true

  # Validations for required dates and location
  validates :location, :start_date, :finish_date, presence: true

  # Custom validation methods
  validate :validate_start_date
  validate :validate_finish_date

  # Validations for numeric fields
  validates :ticket_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: false
  validates :participant_capacity, numericality: { greater_than_or_equal_to: 0 }, allow_nil: false

  validates :status, inclusion: { in: statuses.keys }

  def joinable?
    JOINABLE.include?(status.to_sym)
  end

  def available_tickets
    participant_capacity - event_members.count
  end

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
end
