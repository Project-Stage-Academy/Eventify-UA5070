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
    events = sort_events(events)
    paginate_events(events)
  end

  private

  def sort_events(events)
    sort_column = SORTABLE_COLUMNS[@params[:sort].to_s] || :id
    sort_direction = %w[asc desc].include?(@params[:direction]) ? @params[:direction].to_sym : :asc
    events.order(sort_column => sort_direction)
  end

  def paginate_events(events)
    per_page = [ @params[:per_page].to_i, 50 ].min
    per_page = 10 if per_page <= 0
    events.page(@params[:page]).per(per_page)
  end
end
