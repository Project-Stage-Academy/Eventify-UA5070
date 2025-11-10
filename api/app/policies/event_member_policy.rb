class EventMemberPolicy < ApplicationPolicy
  def show?
    record.user == user || user.has_role?(:admin)
  end

  def update?
    record.user == user
  end

  def destroy?
    user.has_role?(:admin)
  end
end
