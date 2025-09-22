class EventsController < ApplicationController
  def index
    events = Event.all

    #sorting
    sortable = {
      "title" => :title,
      "date"  => :created_at,
      "id"    => :id
    }

    sort_column = sortable[params[:sort]] || :id
    sort_direction = params[:direction] == "desc" ? :desc : :asc
    events = events.order(sort_column => sort_direction)

    #pagination         
    @events = events.page(params[:page]).per(params[:per_page] || 10)

    render json: {
      data: events.as_json,
      pagination: {
        current_page: events.current_page,
        total_pages: events.total_pages,
        total_count: events.total_count
      }
    }
  end

  def show
    @event = Event.find(params[:id])
    render json:{data: @event.as_json}
  end

  def create
  end
end
