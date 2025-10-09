class Api::V1::EventsController < ApplicationController
  include Serialization
  include JsonErrorRendering

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

  private

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
