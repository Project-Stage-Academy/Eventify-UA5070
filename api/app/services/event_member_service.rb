class EventMemberService
  extend Sortable
  extend Paginatable

  Result = Struct.new(:success, :event_member, :errors)

  SORTABLE_COLUMNS = {
    **EventService::SORTABLE_COLUMNS,
    "event_id" => :event_id,
    "rating" => :rating
  }.freeze

  def self.fetch(params, current_user)
    scope = current_user.event_members.joins(:event)
    scope = sort(scope, params, SORTABLE_COLUMNS)
    scope = paginate(scope, params)

    scope.preload(:event)
  end

  def self.create(params, current_user)
    event = extract_event(params)
    number_of_tickets = extract_number_of_tickets(params)
    event_members = []

    ActiveRecord::Base.transaction do
      event.with_lock do
        raise Api::Errors::CommonError::Forbidden.new(id: event.id) unless event.joinable?

        check_tickets_availability(event, number_of_tickets)

        event_members = Array.new(number_of_tickets) do
          EventMember.new(
            event: event,
            user: current_user,
            ticket_qr_code: SecureRandom.uuid
          )
        end

        event_members.each(&:save!)
      end
    end

    Result.new(true, event_members, [])

  rescue ActiveRecord::RecordInvalid => e
    errors = event_members.map { |em| em.errors.full_messages }
    Result.new(false, event_members, errors.presence || [ e.message ])
  end

  def self.rate(event_member, params, current_user)
    if event_member.update(rating: params[:rating], comment: params[:comment])
      Result.new(true, event_member, [])
    else
      Result.new(false, event_member, event_member.errors.full_messages)
    end
  end

  private

  def self.extract_event(params)
    event = Event.find_by(id: params[:event_id])
    raise Api::Errors::EventError::NotFound.new(id: params[:event_id]) if event.nil?

    event
  end

  def self.extract_number_of_tickets(params)
    num = params[:number_of_tickets].to_i
    num = 1 if num <= 0

    num
  end

  def self.check_tickets_availability(event, requested)
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
