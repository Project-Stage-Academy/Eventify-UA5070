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
    @event_member = EventMember.find(params[:id])

    authorize @event_member

    render json: { data: EventMemberSerializer.new(@event_member, view: :full).as_json }

  rescue ActiveRecord::RecordNotFound
    raise Api::Errors::EventMemberError::NotFound.new(id: params[:id])
  end

  def create
    result = EventMemberService.create(event_member_params, current_user)

    if result.success
      data = Array(result.event_member).map { |em| EventMemberSerializer.new(em, view: :full).as_json }
      render json: { data: data }, status: :created
    else
      raise Api::Errors::EventMemberError::ValidationError.new(meta: { errors: result.errors })
    end
  end

  def rate
    @event_member = EventMember.find(params[:event_member_id])
    authorize @event_member

    result = EventMemberService.rate(@event_member, rate_params, current_user)

    if result.success
      render json: { data: EventMemberSerializer.new(result.event_member, view: :full).as_json }, status: :ok
    else
      raise Api::Errors::EventMemberError::ValidationError.new(meta: { errors: result.errors })
    end
  end

  private

  def event_member_params
    params.expect(event_member: [ :event_id, :number_of_tickets ])
  end

  def rate_params
    params.expect(event_member: [ :rating, :comment ])
  end
end
