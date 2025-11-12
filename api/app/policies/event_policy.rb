class EventPolicy < ApplicationPolicy
  def update?
    !(record.archived? || record.cancelled?)
  end

  def publish?
    true
    # TODO: replace with organizer check when organizers are implemented
  end
end
