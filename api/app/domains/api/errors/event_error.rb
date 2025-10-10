module Api
  module Errors
    module EventError
      class ValidationError < BaseError
        def initialize(meta: nil)
          super(
            code: :"event.validation_error",
            status: :unprocessable_entity,
            meta: (meta || {})
          )
        end
      end

      class NotFound < BaseError
        def initialize(id:, meta: nil)
          super(
            code: :"event.not_found",
            status: :not_found,
            meta: (meta || {}).merge(id: id),
            i18n: { id: id }
          )
        end
      end
    end
  end
end
