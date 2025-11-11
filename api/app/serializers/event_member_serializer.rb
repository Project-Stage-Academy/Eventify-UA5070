class EventMemberSerializer < Blueprinter::Base
  identifier :id

  fields :ticket_qr_code, :rating, :comment

  view :with_event do
    include_view :default
    field :event_id
  end

  view :full do
    include_view :with_event
    field :user_id
  end
end
