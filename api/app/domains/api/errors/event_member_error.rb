module Api
  module Errors
    module EventMemberError
      class ValidationError < BaseError
        def initialize(meta: nil)
          super(
            code: :"event_member.validation_error",
            status: :unprocessable_entity,
            meta: (meta || {})
          )
        end
      end

      class NotFound < BaseError
        def initialize(id:, meta: nil)
          super(
            code: :"event_member.not_found",
            status: :not_found,
            meta: (meta || {}).merge(id: id),
            i18n: { id: id }
          )
        end
      end
    end
  end
end
