class EventPolicy < ApplicationPolicy
  def update?
    !(record.archived? || record.cancelled?)
  end
end
