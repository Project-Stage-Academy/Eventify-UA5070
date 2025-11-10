class EventPolicy < ApplicationPolicy
  def update?
    return true if user.has_role?(:admin)
    !(record.archived? || record.cancelled?)
  end
  def update_status?
    user.has_role?(:admin)
  end
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.has_role?(:admin)
        scope.all
      else
        scope.where(user_id: user.id).or(scope.published)
      end
    end
  end
end
