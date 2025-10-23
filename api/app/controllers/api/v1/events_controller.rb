class Api::V1::EventsController < ApplicationController
  include Serialization

  before_action :validate_id_param, only: [ :show, :update ]

  def index
    @events = EventService.fetch(params)

    render json: {
      data: serialized_events(@events),
      pagination: pagination_meta(@events)
   }
  end

  def show
    event = Event.find(params[:id])
    render json: { data: EventSerializer.new(event).as_json }
  rescue ActiveRecord::RecordNotFound
    raise Api::Errors::EventError::NotFound.new(id: params[:id])
  end

  def create
    result = EventService.create(event_params)

    if result.success
      render json: { data: EventSerializer.new(result.event).as_json }, status: :created
    else
      raise Api::Errors::EventError::ValidationError.new(meta: { errors: result.errors })
    end
  end

  def update
    event = Event.find(params[:id])
    authorize event
    result = EventService.update(params[:id], event_params)

    if result.success
      render json: { data: EventSerializer.new(result.event).as_json }, status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Event not found", id: params[:id] }, status: :not_found
  end

  private

  def validate_id_param
    validation_result = Api::V1::IdParamSchema.call(params.to_unsafe_h)

    unless validation_result.success?
      raise Api::Errors::EventError::ValidationError.new(
        meta: { errors: validation_result.errors.to_h }
      )
    end

    params.merge!(validation_result.to_h)
  end

  # Strong params
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
end
