class EventMemberService
  def self.fetch(params, current_user)
    EventMember.where(event_id: params[:event_id], user: current_user)
  end

  def self.create(event, params, current_user)
    number_of_tickets = extract_number_of_tickets(params)
    event_members = []

    ActiveRecord::Base.transaction do
      event.with_lock do
        raise Api::Errors::CommonError::InvalidParams.new(id: event.id) unless event.joinable?

        check_tickets_availability(event, number_of_tickets)

        event_members = Array.new(number_of_tickets) do
          EventMember.new(
            event: event,
            user: current_user,
            ticket_qr_code: SecureRandom.uuid
          )
        end

        EventMember.import!(event_members)
      end
    end

    event_members
  end

  private

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
