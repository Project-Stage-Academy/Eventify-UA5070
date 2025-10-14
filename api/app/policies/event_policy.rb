class EventPolicy < ApplicationPolicy
  # record → Event
  def update?
    !(record.archived? || record.cancelled?)
  end

end
