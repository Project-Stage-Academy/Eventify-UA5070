class Events::FetchEventsService
  include Sortable
  include Paginatable

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
    events = sort(events, @params, SORTABLE_COLUMNS)
    paginate(events, @params)
  end
end
