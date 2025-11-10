# class EventMemberSerializer
#   def initialize(event_member, view: :default)
#     @event_member = event_member
#     @view = view
#   end
#
#   def as_json(*)
#     base = {
#       id: @event_member.id,
#       ticket_qr_code: @event_member.ticket_qr_code,
#       rating: @event_member.rating,
#       comment: @event_member.comment
#     }
#
#     case @view
#     when :with_event
#       base.merge({
#         event_id: @event_member.event_id
#       })
#     when :full
#       base.merge({
#         event_id: @event_member.event_id,
#         user_id: @event_member.user_id
#       })
#     else
#       base
#     end
#   end
# end
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