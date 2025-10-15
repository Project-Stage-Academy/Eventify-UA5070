class Api::V1::EventOrganizersController < ApplicationController
  before_action :set_event

  # POST /api/v1/events/:event_id/organizers
  def create
    authorize @event, :manage_organizers?

    @organizer = @event.event_organizers.new(user_id: params[:user_id])

    if @organizer.save
      render json: { id: @organizer.user.id, name: @organizer.user.name }, status: :created
    else
      raise Api::Errors::EventOrganizersError::ValidationError.new(
        meta: { errors: @organizer.errors.full_messages }
      )
    end
  end

  # DELETE /api/v1/events/:event_id/organizers/:user_id
  def destroy
    authorize @event, :manage_organizers?

    @organizer = @event.event_organizers.find_by(user_id: params[:user_id])

    raise Api::Errors::EventOrganizersError::NotFound.new(
      event_id: params[:event_id],
      user_id: params[:user_id]
    ) unless @organizer

    if @event.event_organizers.count <= 1
      raise Api::Errors::EventOrganizersError::CannotRemoveLastOrganizer.new(
        event_id: params[:event_id]
      )
    end

    @organizer.destroy
    head :ok
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end
