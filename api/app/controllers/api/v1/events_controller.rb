class Api::V1::EventsController < Api::V1::BaseController
  include Serialization

  before_action :validate_id_param, only: [ :show, :update ]

  def index
    @events = EventService.new(params).fetch

    render json: {
      data: serialized_events(@events),
      pagination: pagination_meta(@events)
   }
  end

  def joined
    @events = EventService.new(params).fetch_joined(current_user)

    render json: {
      data: serialized_events(@events),
      pagination: pagination_meta(@events)
    }
  end

  def show
    find_event!

    render json: { data: EventSerializer.new(@event, view: :full).as_json }
  end

  def create
    result = EventService.new(event_params).create(current_user)

    if result.success
      render json: { data: EventSerializer.new(result.event, view: :full).as_json }, status: :created
    else
      raise Api::Errors::EventError::ValidationError.new(meta: { errors: result.errors })
    end
  end

  def update
    find_event!

    authorize @event

    result = EventService.new(event_params).update(@event)

    if result.success
      render json: { data: EventSerializer.new(result.event).as_json }, status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.require(:event).permit(
      :title,
      :description,
      :location,
      :coordinates,
      :start_date,
      :finish_date,
      :participant_capacity,
      :ticket_price,
      :status,
      :proposed_title,
      :proposed_desc,
      :proposed_location
    )
  end

  def find_event!
    @event = Event.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    raise Api::Errors::EventError::NotFound.new(id: params[:id])
  end
end
