class Api::V1::EventOrganizersController < ApplicationController
  before_action :set_event
  before_action :authorize_user!, only: [ :create, :destroy ]

  def create
    @organizer = @event.event_organizers.new(user_id: params[:user_id])

    if @organizer.save
      render json: { id: @organizer.user.id, name: @organizer.user.name }, status: :created
    else
      render json: { errors: @organizer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @organizer = @event.event_organizers.find_by(user_id: params[:user_id])
    unless @organizer
      return render json: { error: I18n.t("errors.common.organizer_not_found") }, status: :not_found
    end

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

  def authorize_user!
    unless current_user.admin? || @event.users.include?(current_user)
      render json: { error: I18n.t("errors.common.not_authorized") }, status: :forbidden
    end
  end
end
