class EventSerializer
  def initialize(event, view: :default)
    @event = event
    @view = view
  end

  def as_json(*)
    base = {
      id: @event.id,
      title: @event.title,
      description: @event.description,
      location: @event.location,
      start_date: @event.start_date,
      finish_date: @event.finish_date,
      ticket_price: @event.ticket_price,
      status: @event.status,
      average_rating: @event.average_rating,
      rating_count: @event.rating_count
    }

    case @view
    when :full
      base.merge({
        coordinates: @event.coordinates,
        participant_capacity: @event.participant_capacity,
        proposed_title: @event.proposed_title,
        proposed_desc: @event.proposed_desc,
        proposed_location: @event.proposed_location,
        review_comment: @event.review_comment
      })
    else
      base
    end
  end
end
