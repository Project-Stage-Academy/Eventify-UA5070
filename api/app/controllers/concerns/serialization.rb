module Serialization
  extend ActiveSupport::Concern

  def serialized_events(events, view: :default)
    events.map { |event| EventSerializer.new(event, view: view).as_json }
  end

  def serialized_event_members(event_members, view: :default)
    event_members.map { |em| EventMemberSerializer.new(em, view: view).as_json }
  end

  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count,
      per_page: collection.limit_value
    }
  end
end
