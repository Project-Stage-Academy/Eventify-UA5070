class Api::V1::EventOrganizersController < ApplicationController
  before_action :set_event

  def create
    authorize @event, :manage_organizers?

    user_id = organizer_params[:user_id]
    @organizer = @event.event_organizers.new(user_id: user_id)

    if @organizer.save
      render json: { id: @organizer.user.id, name: @organizer.user.name }, status: :created
    else
      render json: { errors: @organizer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @event, :manage_organizers?

    organizer = @event.event_organizers.find_by(user_id: params[:user_id])

    unless organizer
      render json: { error: "Organizer not found" }, status: :not_found
      return
    end

    begin
      organizer.destroy!
      head :ok
    rescue ActiveRecord::RecordNotDestroyed
      render json: { error: "Cannot remove the last organizer" }, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find_by(id: params[:event_id])
    raise Api::Errors::EventError::NotFound.new(
      event_id: params[:event_id],
      user_id: nil
    ) unless @event
  end

  def organizer_params
    params.require(:user_id)
    params.permit(:user_id)
  end
end
