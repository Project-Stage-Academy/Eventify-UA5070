class EventService
  include Sortable
  include Paginatable

  def initialize(params)
    @params = params
  end

  Result = Struct.new(:success, :event, :errors, keyword_init: true)

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

    Result.new(success: true, event: event, errors: [])
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Validation failed: #{e.record.errors.full_messages.join(', ')}")
    Result.new(success: false, event: nil, errors: e.record.errors.full_messages.uniq)
  rescue ActiveRecord::RecordNotUnique => e
    Rails.logger.error("Record not unique: #{e.message}\n#{e.backtrace.join("\n")}")
    Result.new(success: false, event: nil, errors: [ "A record with these details already exists." ])
  rescue ActiveRecord::StatementInvalid => e
    Rails.logger.error("Database statement invalid: #{e.message}\n#{e.backtrace.join("\n")}")
    Result.new(success: false, event: nil, errors: [ "There was a problem saving the event. Please check your input and try again." ])
  end

  def update(event)
    if event.update(@params)
      Result.new(success: true, event: event, errors: [])
    else
      Result.new(success: false, event: nil, errors: event.errors.full_messages)
    end
  end
end
