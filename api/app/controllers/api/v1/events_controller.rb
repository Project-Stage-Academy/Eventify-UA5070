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

    return render_error(["Event not found"], :not_found) if event.nil?

    render json: { data: EventSerializer.new(event).as_json }

  end

  def create
    event = Events::CreateEventService.new(event_params).call
    unless event.persisted? 
      return render_error(event.errors.full_messages, :unprocessable_entity)
    end

    render json: { data: EventSerializer.new(event).as_json }, status: :created

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

   def render_error(errors, status)
    render json: { errors: errors }, status: status
  end

end
