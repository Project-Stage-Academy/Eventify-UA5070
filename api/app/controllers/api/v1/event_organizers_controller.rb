class Api::V1::EventOrganizersController < ApplicationController
  before_action :set_event

  def create
    authorize @event, :manage_organizers?

    user_id = organizer_params[:user_id]
    user = User.find_by(id: user_id)

    unless user
      render json: { error: I18n.t("errors.user.not_found") }, status: :not_found
      return
    end

    @organizer = @event.event_organizers.new(user: user)

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
      render json: { error: I18n.t("errors.common.organizer_not_found") }, status: :not_found
      return
    end

    begin
      organizer.destroy!
      render json: { message: I18n.t("activerecord.errors.models.event_organizer.messages.organizer_removed") }, status: :ok
    rescue ActiveRecord::RecordNotDestroyed
      render json: { error: I18n.t("activerecord.errors.models.event_organizer.messages.last_organizer_removal_forbidden") }, status: :unprocessable_entity
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
