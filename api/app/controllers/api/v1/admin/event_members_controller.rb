class Api::V1::Admin::EventMembersController < Api::V1::Admin::AdminBaseController
  before_action :find_event_member!

  def update
    authorize @event_member, :update_rating?

    if @event_member.update(rate_params)
      render json: { data: EventMemberSerializer.render_as_hash(@event_member, view: :full) }, status: :ok
    else
      render json: { errors: @event_member.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @event_member

    @event_member.destroy!
    render json: { message: "Membership cancelled successfully" }, status: :no_content
  end

  private

  def rate_params
    params.expect(event_member: [ :rating, :comment ])
  end

  def find_event_member!
    @event_member = EventMember.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    raise Api::Errors::EventMemberError::NotFound.new(id: params[:id])
  end
end
