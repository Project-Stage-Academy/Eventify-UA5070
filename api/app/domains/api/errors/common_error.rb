module Api
  module Errors
    module CommonError
      BASE = :common

      class InvalidParams < BaseError
        CODE = :"#{BASE}.invalid_params"

        def initialize(meta: nil, **)
          super(code: CODE, status: :unprocessable_entity, meta: meta)
        end
      end

      class Forbidden < BaseError
        CODE = :"#{BASE}.forbidden"

        def initialize(meta: nil, **)
          super(code: CODE, status: :forbidden, meta: meta)
        end
      end
    end
  end
end
