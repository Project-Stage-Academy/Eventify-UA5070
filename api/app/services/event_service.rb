class EventService
  include Sortable
  include Paginatable

  def initialize(params)
    @params = params
  end

  Result = Struct.new(:success, :event, :errors)

  SORTABLE_COLUMNS = {
    "title" => :title,
    "start_date" => :start_date,
    "id" => :id
  }.freeze

  def fetch
    events = Event.all
    events = sort(events, @params, SORTABLE_COLUMNS)
    paginate(events, @params)
  end

  def fetch_joined(user)
    events = user.joined_events.distinct
    events = sort(events, @params, SORTABLE_COLUMNS)
    paginate(events, @params)
  end

  def create(user)
    event = Event.new(@params)

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
    Result.new(false, nil, ["An unexpected error occurred. Please try again later."])
  end

  def update(event)
    if event.update(@params)
      Result.new(true, event, [])
    else
      Result.new(false, nil, event.errors.full_messages)
    end
  end
end
