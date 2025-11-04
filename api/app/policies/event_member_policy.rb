class EventMemberPolicy < ApplicationPolicy
  def show?
    record.user == user || user.has_role?(:admin)
  end

  def update?
    record.user == user
  end
end
