module Api
  module Errors
    module EventMemberError
      BASE = :event_member

      class ValidationError < ValidationBaseError
        def initialize(meta: nil)
          super(
            code_prefix: BASE,
            meta: (meta || {})
          )
        end
      end

      class NotFound < NotFoundBase
        def initialize(id:, meta: nil)
          super(
            code_prefix: BASE,
            meta: (meta || {}).merge(id: id),
            i18n: { id: id }
          )
        end
      end

      class TicketsOverflow < BaseError
        CODE = :"#{BASE}.tickets_overflow"

        def initialize(event_id:, requested:, available:, meta: nil)
          super(
            code: CODE,
            status: :unprocessable_entity,
            meta: (meta || {}).merge(
              event_id: event_id,
              requested: requested,
              available: available
            ),
            i18n: { event_id: event_id, requested: requested, available: available }
          )
        end
      end
    end
  end
end
