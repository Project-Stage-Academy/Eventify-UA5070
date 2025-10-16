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

 def self.create(params, user)
  event = Event.new(params)

  if event.save
    organizer = EventOrganizer.new(event: event, user: user, is_primary: true)

    unless organizer.save
      event.destroy
      return Result.new(false, nil, organizer.errors.full_messages)
    end

    Result.new(true, event, [])
  else
    Result.new(false, nil, event.errors.full_messages)
  end
  rescue StandardError => e
    Result.new(false, nil, [ e.message ])
  end
end
