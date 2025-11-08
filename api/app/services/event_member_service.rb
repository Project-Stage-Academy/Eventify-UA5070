class EventMemberService
  include Sortable
  include Paginatable

  def initialize(user)
    @user = user
  end

  SORTABLE_COLUMNS = {
    "rating" => :rating,
    "date" => :updated_at
  }.freeze

  def fetch(params)
    EventMember.where(event_id: params[:event_id], user: @user)
  end

  def fetch_reviews(params)
    members_with_review = EventMember.where(event_id: params[:event_id]).where.not(rating: nil)
    members_with_review = sort(members_with_review, params, SORTABLE_COLUMNS)

    paginate(members_with_review, params)
  end

  def create!(event, params)
    number_of_tickets = extract_number_of_tickets(params)
    event_members = []

    ActiveRecord::Base.transaction do
      event.with_lock do
        raise Api::Errors::CommonError::InvalidParams.new(id: event.id) unless event.joinable?

        check_tickets_availability(event, number_of_tickets)

        event_members = Array.new(number_of_tickets) do
          EventMember.new(
            event: event,
            user: @user,
            ticket_qr_code: SecureRandom.uuid
          )
        end

        EventMember.import!(event_members)
      end
    end

    event_members

  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
    raise Api::Errors::EventMemberError::ValidationError.new
  end

  def update!(event_member, params)
    event_member.update!(rating: params[:rating], comment: params[:comment])

    event_member.event.update_rating_fields

    event_member

  rescue ActiveRecord::RecordInvalid => e
    raise Api::Errors::EventMemberError::ValidationError.new(meta: e.record.errors.full_messages)
  end

  private

  def extract_number_of_tickets(params)
    num = params[:number_of_tickets].to_i
    num = 1 if num <= 0

    num
  end

  def check_tickets_availability(event, requested)
    available = event.available_tickets

    if available < requested
      raise Api::Errors::EventMemberError::TicketsOverflow.new(
        event_id: event.id,
        requested: requested,
        available: available
      )
    end
  end
end
