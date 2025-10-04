class EventPolicy < ApplicationPolicy
  def update?
    user.admin? || record.users.include?(user)
  end

  def destroy?
    user.admin? || record.event_organizers.find_by(user: user)&.is_primary?
  end

  def manage_organizers?
    user.admin? || record.event_organizers.find_by(user: user)&.is_primary?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.joins(:event_organizers).where(event_organizers: { user_id: user.id }).distinct
      end
    end
  end
end
