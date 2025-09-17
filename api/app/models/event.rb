class Event < ApplicationRecord
  belongs_to :organizer, class_name: "User", optional: true

  enum status: {
    published: "PUBLISHED",
    draft: "DRAFT",
    cancelled: "CANCELLED",
    completed: "COMPLETED",
    in_review: "IN_REVIEW",
    rejected: "REJECTED",
    archives: "ARCHIVED"
  }

  validates :title, presence: true, length: { maximum: 150 }
  validates :description, length: { maximum: 500 }, allow_blank: true
  validates :location, presence: true
  validates :start_date, presence: true
  validates :finish_date, presence: true
  validate  :start_date_in_future
  validate  :finish_date_after_start_date
  validates :ticket_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  private

  def start_date_in_future
    return if start_date.blank?
    if start_date < Time.current
      errors.add(:start_date, "must be in the future")
    end
  end

  def finish_date_after_start_date
    return if start_date.blank? || finish_date.blank?
    if finish_date <= start_date
      errors.add(:finish_date, "must be after start date")
    end
  end
end
