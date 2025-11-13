class Api::V1::EventsController < Api::V1::BaseController
  include Serialization

  before_action :validate_id_param, only: [ :show, :update ]
  before_action :find_event!, only: [ :show, :update ]

  before_action -> do
    validate_id_param(id: :event_id)
    find_event!(id: :event_id)
  end, only: [ :publish, :archive, :cancel, :copy ]

  before_action -> { authorize @event }, only: [ :update, :publish, :archive, :cancel, :copy ]

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
    render json: { data: EventSerializer.new(@event, view: :full).as_json }
  end

  def create
    respond_on_create EventService.new(event_params).create
  end

  def update
    result = EventService.new(event_params).update(@event)

    if result.success
      render json: { data: EventSerializer.new(result.event).as_json }, status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def publish
    default_respond_on EventService.new.publish(@event)
  end

  def archive
    default_respond_on EventService.new.archive(@event)
  end

  def cancel
    default_respond_on EventService.new.cancel(@event)
  end

  def copy
    respond_on_create EventService.new.copy(@event)
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
      :ticket_price
    )
  end

  def find_event!(id: :id)
    @event = Event.find(params[id])

  rescue ActiveRecord::RecordNotFound
    raise Api::Errors::EventError::NotFound.new(id: params[id])
  end

  def default_respond_on(result)
    if result.success
      render json: {}, status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def respond_on_create(result)
    if result.success
      render json: { data: EventSerializer.new(result.event, view: :full).as_json }, status: :created
    else
      raise Api::Errors::EventError::ValidationError.new(meta: { errors: result.errors })
    end
  end
end
