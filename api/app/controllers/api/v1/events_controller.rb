class Api::V1::EventsController < ApplicationController
  def index
    events = Event.all

    # sorting
    sortable = {
      "title" => :title,
      "start_date" => :start_date,
      "id" => :id
    }

    sort_column = sortable[params[:sort]] || :id
    sort_direction = params[:direction] == "desc" ? :desc : :asc
    events = events.order(sort_column => sort_direction)

    # pagination
    @events = events.page(params[:page]).per(params[:per_page] || 10)

    render json: {
      data: @events.as_json,
      pagination: {
        current_page: @events.current_page,
        total_pages: @events.total_pages,
        total_count: @events.total_count
      }
   }
  end

  def show
    @event = Event.find(params[:id])
    render json: { data: @event.as_json }
  end

  def create
    event = Event.new(event_params)

    if event.save
      render json: { data: event.as_json }, status: :created
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
      :start_date, 
      :finish_date, 
      :participant_capacity, 
      :ticket_price, 
      :status
    )
  end
end
