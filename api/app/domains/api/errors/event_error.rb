module Api
  module Errors
    module EventError
      BASE = :event

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

      class InvalidStatusTransition < BaseError
        def initialize
          super(
            code: :"#{BASE}.invalid_status_transition",
            status: :unprocessable_entity
          )
        end
      end
    end
  end
end
