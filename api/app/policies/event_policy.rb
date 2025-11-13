class EventPolicy < ApplicationPolicy
  def update?
    !(record.archived? || record.cancelled?)
  end

  def publish?
    user_is_organizer?
  end

  def archive?
    user_is_organizer?
  end

  def cancel?
    user_is_organizer?
  end

  def copy?
    user_is_organizer?
  end

  private

  def user_is_organizer?
    true
    # TODO: replace with organizer check when organizers are implemented
  end
end
