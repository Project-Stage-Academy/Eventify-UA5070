class Api::V1::EventMembersController < Api::V1::BaseController
  include Serialization

  before_action :validate_id_param, only: [ :show, :update ]
  before_action -> { validate_id_param(id: :event_id) }, only: [ :index_on_event, :create ]

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
    find_event_member!

    authorize @event_member

    render json: { data: EventMemberSerializer.new(@event_member, view: :full).as_json }
  end

  def create
    @event = Event.find(params[:event_id])

    @event_members = EventMemberService.create(@event, event_member_params, current_user)

    LogEntryCreationJob.perform_later(
      user_id: current_user.id,
      event_id: @event.id,
      action: :event_member_created,
      metadata: {
        ticket_qr_codes: @event_members.map(&:ticket_qr_code)
      }
    )

    render json: { data: serialized_event_members(@event_members, view: :full) }, status: :created

  rescue ActiveRecord::RecordNotFound
    raise Api::Errors::EventError::NotFound.new(id: params[:event_id])
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
    raise Api::Errors::EventMemberError::ValidationError.new
  end

  def update
    find_event_member!

    authorize @event_member

    @event_member.update!(rating: rate_params[:rating], comment: rate_params[:comment])

    render json: { data: EventMemberSerializer.new(@event_member, view: :full).as_json }, status: :ok

  rescue ActiveRecord::RecordInvalid => e
    raise Api::Errors::EventMemberError::ValidationError.new(meta: e.record.errors.full_messages)
  end

  private

  def event_member_params
    params.expect(event_member: [ :number_of_tickets ])
  end

  def rate_params
    params.expect(event_member: [ :rating, :comment ])
  end

  def find_event_member!
  @event_member = EventMember.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    raise Api::Errors::EventMemberError::NotFound.new(id: params[:id])
  end
end
