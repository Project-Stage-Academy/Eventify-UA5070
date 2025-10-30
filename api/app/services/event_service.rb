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

    Event.transaction do
      event.save!
      EventOrganizer.create!(event: event, user: user, is_primary: true)
    end

    Result.new(true, event, [])
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Validation failed: #{e.record.errors.full_messages.join(', ')}")
    Result.new(false, nil, e.record.errors.full_messages.uniq)
  rescue StandardError => e
    Rails.logger.error("EventService#create failed: #{e.class} - #{e.message}\n#{e.backtrace.join("\n")}")
    Result.new(false, nil, [ "An unexpected error occurred. Please try again later." ])
  end

  def self.update(id, attrs)
    event = Event.find(id)
    if event.update(attrs)
      Result.new(success: true, event: event)
    else
      Result.new(success: false, errors: event.errors.full_messages)
    end
  end
end
