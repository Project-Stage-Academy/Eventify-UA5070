module Api
  module Errors
    module EventOrganizersError
      class ValidationError < BaseError
        def initialize(meta: nil)
          super(
            code: :"event_organizer.validation_error",
            status: :unprocessable_entity,
            meta: (meta || {})
          )
        end
      end

      class NotFound < BaseError
        def initialize(event_id:, user_id:, meta: nil)
          super(
            code: :"event_organizer.not_found",
            status: :not_found,
            meta: (meta || {}).merge(event_id: event_id, user_id: user_id),
            i18n: { event_id: event_id, user_id: user_id }
          )
        end
      end

      class CannotRemoveLastOrganizer < BaseError
        def initialize(event_id:, meta: nil)
          super(
            code: :"event_organizer.cannot_remove_last",
            status: :forbidden,
            meta: (meta || {}).merge(event_id: event_id),
            i18n: { event_id: event_id }
          )
        end
      end
    end
  end
end
