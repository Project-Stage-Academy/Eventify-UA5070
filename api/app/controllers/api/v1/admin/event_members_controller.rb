class Api::V1::Admin::EventMembersController < Api::V1::BaseController
  include Serialization

  before_action :find_event_member!

  def update
    authorize [:admin, @event_member]

    if @event_member.update(rate_params)
      render json: { data: EventMemberSerializer.new(@event_member, view: :full).as_json }, status: :ok
    else
      render json: { errors: @event_member.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize [:admin, @event_member]

    @event_member.destroy!
    render json: { message: "Membership cancelled successfully" }, status: :ok
  end

  private

  def rate_params
    params.expect(event_member: [:rating, :comment])
  end

  def find_event_member!
    @event_member = EventMember.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    raise Api::Errors::EventMemberError::NotFound.new(id: params[:id])
  end
end
