class Api::V1::EventOrganizersController < ApplicationController
  before_action :set_event

  # POST /api/v1/events/:event_id/organizers
  def create
    authorize @event, :manage_organizers?

    @organizer = @event.event_organizers.new(user_id: params[:user_id])

    if @organizer.save
      render json: { id: @organizer.user.id, name: @organizer.user.name }, status: :created
    else
      render json: { errors: @organizer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/events/:event_id/organizers/:user_id
  def destroy
    authorize @event, :manage_organizers?

    @organizer = @event.event_organizers.find_by(user_id: params[:user_id])
    return render json: { error: I18n.t("errors.common.organizer_not_found") }, status: :not_found unless @organizer

    if @organizer.destroy
      render json: { message: I18n.t("activerecord.errors.models.event_organizer.messages.organizer_removed") }, status: :ok
    else
      render json: { errors: @organizer.errors.full_messages }, status: :forbidden
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end
