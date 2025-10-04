class Api::V1::EventsController < ApplicationController
  def index
    @events = Events::FetchEventsService.new(params).call

    render json: {
      data: @events.map { |event| EventSerializer.new(event).as_json },
      pagination: {
        current_page: @events.current_page,
        total_pages: @events.total_pages,
        total_count: @events.total_count
      }
   }
  end

  def show
    event = Event.find_by(id: params[:id])

    if event
      render json: { data: EventSerializer.new(event).as_json }
    else
      render json: { errors: [ "Event with id=#{params[:id]} not found" ] }, status: :not_found
    end
  end

  def create
    event = Event.new(event_params)

    if event.save
      render json: { data: EventSerializer.new(event).as_json }, status: :created
    else
      render json: {
        errors: event.errors.full_messages
      }, status: :unprocessable_entity # 422
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
      :event_status,
      :review_status,
      :review_comment
    )
  end
end
