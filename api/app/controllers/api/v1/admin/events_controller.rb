class Api::V1::Admin::EventsController < Api::V1::BaseController
  def index
    events = Event
               .left_joins(:event_members)
               .select('events.*, COUNT(event_members.id) AS member_count')
               .group('events.id')
               .order(created_at: :asc)

    render json: { data: EventSerializer.render_as_hash(events, view: :full) }, status: :ok
  end
  def review
    events = Event.where(status: [:draft_on_review, :published_on_review])

    render json: {
      data: EventSerializer.render_as_hash(events, view: :full)
    }, status: :ok
  end

  def update_review
    event = Event.find(params[:id])
    return render json: { error: "Event not awaiting review" }, status: :unprocessable_entity unless event.reviewable?
    event.update!(status: params[:status])
    render json: { data: { id: event.id, status: event.status } }, status: :ok
  end

  private
end
