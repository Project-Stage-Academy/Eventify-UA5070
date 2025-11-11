class EventSerializer < Blueprinter::Base
  identifier :id

  fields :title,
         :location,
         :start_date,
         :finish_date,
         :ticket_price,
         :status

  field :member_count do |event, _options|
    event.respond_to?(:member_count) ? event.member_count.to_i : 0
  end

  view :full do
    fields :description,
           :coordinates,
           :participant_capacity,
           :proposed_title,
           :proposed_desc,
           :proposed_location,
           :review_comment
  end
end
