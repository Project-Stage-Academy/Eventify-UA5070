class Api::V1::EventMembersController < Api::V1::BaseController
  include Serialization

  def index
    @event_members = EventMemberService.fetch(params, current_user)
    unique_events = @event_members.map(&:event).compact.uniq { |e| e.id }

    render json: {
      data: @event_members.map { |em| EventMemberSerializer.new(em, view: :with_event).as_json },
      included: { events: unique_events.map { |e| EventSerializer.new(e).as_json } },
      pagination: pagination_meta(@event_members)
    }
  end

  def index_on_event
    @event_members = EventMember.where(event_id: params[:event_id], user: current_user)

    render json: {
      data: @event_members.map { |em| EventMemberSerializer.new(em).as_json }
    }
  end

  def show
  end
end
