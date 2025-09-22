class Event < ApplicationRecord
  belongs_to :organizer, class_name: "User", optional: false

  enum status: {
      draft: 0,
      published: 1,
      in_review: 2,
      rejected: 3,
      cancelled: 4,
      completed: 5,
      archived: 6
  }

  # Validations for text fields
  validates :title, presence: true, length: { maximum: 150 }
  validates :description, length: { maximum: 500 }, allow_blank: true

  # Validations for required dates and location
  validates :location, :start_date, :finish_date, presence: true

  # Custom validation methods
  validates :validate_start_date
  validates :validate_finish_date

  # Validations for numeric fields
  validates :ticket_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: false

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
