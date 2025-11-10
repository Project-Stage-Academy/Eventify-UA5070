class Api::V1::Admin::EventsController < Api::V1::BaseController
  include Serialization
  before_action :authorize_admin!

  def index
    events = Event
               .left_joins(:event_members)
               .select('events.*, COUNT(event_members.id) AS member_count')
               .group('events.id')
               .order(created_at: :desc)

    render json: {
      data: events.map { |e|
        {
          id: e.id,
          title: e.title,
          status: e.status,
          member_count: e.member_count.to_i,
          start_date: e.start_date,
          finish_date: e.finish_date
        }
      }
    }, status: :ok
  end
  #test controller/////////////////////////////////////////////////////////
  def show
    event = Event.includes(:event_members, :members).find(params[:id])

    render json: {
      data: {
        id: event.id,
        title: event.title,
        description: event.description,
        status: event.status,
        start_date: event.start_date,
        finish_date: event.finish_date,
        location: event.location,
        ticket_price: event.ticket_price,
        participant_capacity: event.participant_capacity,
        created_at: event.created_at,
        updated_at: event.updated_at,
        members: event.event_members.map do |em|
          {
            id: em.id,
            user_id: em.user_id,
            rating: em.rating,
            comment: em.comment,
            ticket_qr_code: em.ticket_qr_code
          }
        end
      }
    }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Event not found" }, status: :not_found
  end



  def review
    events = Event.where(status: [:draft_on_review, :published_on_review])

    render json: {
      data: events.map { |e|
        {
          id: e.id,
          title: e.title,
          status: e.status,
          created_at: e.created_at
        }
      }
    }, status: :ok
  end

  def update_review
    event = Event.find(params[:id])

    unless event.status.in?(["draft_on_review", "published_on_review"])
      return render json: { error: "Event not awaiting review" }, status: :unprocessable_entity
    end

    new_status = params[:status]

    unless Event.statuses.keys.include?(new_status)
      return render json: { error: "Invalid status" }, status: :unprocessable_entity
    end

    event.update!(status: new_status)
    render json: { data: { id: event.id, status: event.status } }, status: :ok
  end

  private

  def authorize_admin!
    render json: { error: "Access denied" }, status: :forbidden unless current_user.has_role?(:admin)
  end
end
