class Events::CreateEventService
  def initialize(params)
    @params = params
  end

  def call
    event = Event.new(@params)
    event.save
    event
  end
end
