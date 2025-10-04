class Events::FetchEventsService
  SORTABLE_COLUMNS = {
    "title" => :title,
    "start_date" => :start_date,
    "id" => :id
  }.freeze

  def initialize (params)
    @params = params
  end

  def call
    events = Event.all

    sort_column = SORTABLE_COLUMNS[@params[:sort]] || :id
    sort_direction = @params[:direction] == "desc" ? :desc : :asc
    events = events.order(sort_column => sort_direction)

    # pagination
    @events = events.page(@params[:page]).per(@params[:per_page] || 10)
  end
end
