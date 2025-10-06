class EventPolicy < ApplicationPolicy
  def update?
    user.has_role?(:admin) || record.organizers.include?(user)
  end

  def destroy?
  user.has_role?(:admin) || !!record.event_organizers.find_by(user: user)&.is_primary?
  end

  def manage_organizers?
    user.has_role?(:admin) || !!record.event_organizers.find_by(user: user)&.is_primary?
  end
end
