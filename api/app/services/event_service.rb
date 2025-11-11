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
    "id" => :id,
    "rating" => :average_rating,
    "rating_count" => :rating_count
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

  def create
    event = Event.new(@params)

    if event.save
      Result.new(true, event, [])
    else
      Result.new(false, event, event.errors.full_messages)
    end
  end

  def update(event)
    if event.update(@params)
      Result.new(success: true, event: event)
    else
      Result.new(success: false, errors: event.errors.full_messages)
    end
  end
end
