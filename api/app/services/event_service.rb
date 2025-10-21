class EventService
  extend Sortable
  extend Paginatable

  Result = Struct.new(:success, :event, :errors)

  SORTABLE_COLUMNS = {
    "title" => :title,
    "start_date" => :start_date,
    "id" => :id
  }.freeze

  def self.fetch(params)
    events = Event.all
    events = sort(events, params, SORTABLE_COLUMNS)
    paginate(events, params)
  end

  def self.create(params, user)
    event = Event.new(params)
    organizer = EventOrganizer.new(event: event, user: user, is_primary: true)

    Event.transaction do
      event.save!
      organizer.save!
    end

    Result.new(true, event, [])
  rescue ActiveRecord::RecordInvalid => e
    errors = e.record.errors.full_messages
    Result.new(false, nil, errors.uniq)
  rescue StandardError => e
    Rails.logger.error("EventService#create failed: #{e.class} - #{e.message}\n#{e.backtrace.join("\n")}")
    Result.new(false, nil, [ "An unexpected error occurred. Please try again later." ])
  end
end
