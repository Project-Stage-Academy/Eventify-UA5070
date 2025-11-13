class EventMemberSerializer
  def initialize(event_member, view: :default)
    @event_member = event_member
    @view = view
  end

  def as_json(*)
    base = {
      id: @event_member.id,
      ticket_qr_code: @event_member.ticket_qr_code,
      rating: @event_member.rating,
      comment: @event_member.comment
    }

    case @view
    when :review
      {
        username: @event_member.user.name,
        rating: @event_member.rating,
        comment: @event_member.comment,
        date: @event_member.updated_at.to_date
      }
    when :with_event
      base.merge({
        event_id: @event_member.event_id
      })
    when :full
      base.merge({
        event_id: @event_member.event_id,
        user_id: @event_member.user_id
      })
    else
      base
    end
  end
end
