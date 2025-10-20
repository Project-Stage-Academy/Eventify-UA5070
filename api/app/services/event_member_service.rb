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

  def self.create(event, number_of_tickets, current_user)
    event_members = Array.new(number_of_tickets) do
      EventMember.new(
        event: event,
        user: current_user,
        ticket_qr_code: SecureRandom.uuid
      )
    end

    ActiveRecord::Base.transaction do
      event_members.each(&:save!)
    end

    Result.new(true, event_members, [])

  rescue ActiveRecord::RecordInvalid => e
    errors = event_members.flat_map { |em| em.errors.full_messages }
    Result.new(false, event_members, errors.presence || [ e.message ])
  end
end
