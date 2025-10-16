module Serialization
  extend ActiveSupport::Concern

  def serialized_events(events)
    events.map { |event| EventSerializer.new(event).as_json }
  end

  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end
end
