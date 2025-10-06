class EventSerializer
  def initialize(event)
    @event = event
  end

  def as_json(*)
    {
      id: @event.id,
      title: @event.title,
      description: @event.description,
      location: @event.location,
      coordinates: @event.coordinates,
      start_date: @event.start_date,
      finish_date: @event.finish_date,
      participant_capacity: @event.participant_capacity,
      ticket_price: @event.ticket_price,
      status: @event.status,
      proposed_title:@event.proposed_title,
      proposed_desc:@event.proposed_desc,
      proposed_location:@event.proposed_location,
      review_comment: @event.review_comment
    }
  end
end
