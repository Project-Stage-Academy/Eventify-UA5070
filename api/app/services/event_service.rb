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
    events = self.sort(events, params, SORTABLE_COLUMNS)
    self.paginate(events, params)
  end

  def self.create(params)
    event = Event.new(params)

    if event.save
      Result.new(true, event, [])
    else
      Result.new(false, event, event.errors.full_messages)
    end
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

