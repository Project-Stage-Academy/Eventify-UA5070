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
    event.status = :draft

    if event.save
      Result.new(true, event, [])
    else
      Result.new(false, event, event.errors.full_messages)
    end
  end

  def update(event)
    update_params = @params.dup
    hard_changed = Event.change_hard_fields_to_proposed(update_params)

    new_status = Event::STATUS_ON_UPDATE.fetch(event.status.to_sym, nil)
    update_params[:status] = new_status.respond_to?(:call) ? new_status.call(hard_changed) : new_status

    if event.update(update_params)
      Result.new(success: true, event: event)
    else
      Result.new(success: false, errors: event.errors.full_messages)
    end
  end

  def publish(event)
    new_status = Event::STATUS_ON_PUBLISH.fetch(event.status.to_sym, nil)

    update_status(event, new_status)
  end

  def archive(event)
    new_status = Event::STATUS_ON_ARCHIVE.fetch(event.status.to_sym, nil)

    update_status(event, new_status)
  end

  def cancel(event)
    new_status = Event::STATUS_ON_CANCEL.fetch(event.status.to_sym, nil)

    update_status(event, new_status)
  end

  private

  def update_status(event, new_status)
    if new_status.present? && event.update(status: new_status)
      Result.new(success: true)
    else
      Result.new(success: false, errors: event.errors.full_messages)
    end
  end
end
