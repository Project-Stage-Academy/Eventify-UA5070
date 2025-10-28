module Api
  module Errors
    module EventError
      class ValidationError < ValidationBaseError
        def initialize(meta: nil)
          super(
            code_prefix: :event,
            meta: (meta || {})
          )
        end
      end

      class NotFound < NotFoundBase
        def initialize(id:, meta: nil)
          super(
            code_prefix: :event,
            meta: (meta || {}).merge(id: id),
            i18n: { id: id }
          )
        end
      end
    end
  end
end
