class EventMemberPolicy < ApplicationPolicy
  def show?
    record.user == user || user.has_role?(:admin)
  end

  def rate?
    record.user == user
  end
end
