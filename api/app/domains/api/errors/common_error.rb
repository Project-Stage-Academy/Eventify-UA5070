module Api
  module Errors
    module CommonError
      class InvalidParams < BaseError
        def initialize(meta: nil, **)
          super(code: :"common.invalid_params", status: :unprocessable_entity, meta: meta)
        end
      end

      class Forbidden < BaseError
        def initialize(meta: nil, **)
          super(code: :"common.forbidden", status: :forbidden, meta: meta)
        end
      end
    end
  end
end
