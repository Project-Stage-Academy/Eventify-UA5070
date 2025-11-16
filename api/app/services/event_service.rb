class EventService
  include Sortable
  include Paginatable

  def initialize(params = nil)
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
    save_new_event Event.new(@params)
  end

  def update(event)
    update_params = @params.dup
    hard_changed = change_hard_fields_to_proposed(update_params)

    new_status = EventStatusService.new(event).status_on_update(hard_changed)

    update_params[:status] = new_status

    if event.update(update_params)
      EventStatusService.new(event).schedule_auto_approve_if_needed(new_status)

      Result.new(success: true, event: event)
    else
      Result.new(success: false, errors: event.errors.full_messages)
    end
  end

  def publish(event)
    update_status(event, EventStatusService.new(event).status_on_publish)
  end

  def archive(event)
    update_status(event, EventStatusService.new(event).status_on_archive)
  end

  def cancel(event)
    update_status(event, EventStatusService.new(event).status_on_cancel)
  end

  def copy(event)
    raise Api::Errors::EventError::InvalidStatusTransition.new() unless event.copyable?

    EventStatusService.new(event).generate_copy_title

    save_new_event event.dup
  end

  private

  def update_status(event, new_status)
    if EventStatusService.new(event).update_status(new_status)
      Result.new(success: true)
    else
      Result.new(success: false, errors: event.errors.full_messages)
    end
  end

  def save_new_event(event)
    event.status = EventStatusService::INITIAL_STATUS

    if event.save
      Result.new(success: true, event: event)
    else
      Result.new(success: false, errors: event.errors.full_messages)
    end
  end

  def change_hard_fields_to_proposed(params)
    hard_changed = false

    Event::HARD_TO_PROPOSED.each do |field, proposed_field|
      next unless params.key?(field)

      params[proposed_field] = params.delete(field)
      hard_changed = true
    end

    hard_changed
  end
end
