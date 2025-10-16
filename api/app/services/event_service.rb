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
    event = nil

    Event.transaction do
      event = Event.new(params)

      unless event.save
        raise ActiveRecord::Rollback
      end

      organizer = EventOrganizer.new(event: event, user: user, is_primary: true)

      unless organizer.save
        raise ActiveRecord::Rollback
      end
    end

    if event&.persisted?
      Result.new(true, event, [])
    else
      errors = (event&.errors&.full_messages || []) +
               (event&.event_organizers&.first&.errors&.full_messages || [])
      Result.new(false, nil, errors.uniq)
    end
  rescue StandardError => e
    Rails.logger.error("EventService#create failed: #{e.class} - #{e.message}\n#{e.backtrace.join("\n")}")

    Result.new(false, nil, [ "An unexpected error occurred. Please try again later." ])
  end
end
