module Api
  module Errors
    module UserError
      BASE = :user

      class NotFound < NotFoundBase
        def initialize(meta: nil, **)
          super(code_prefix: BASE, meta: meta)
        end
      end

      class EmailTaken < BaseError
        CODE = :"#{BASE}.email_taken"

        def initialize(meta: nil, **)
          super(code: CODE, status: :unprocessable_entity, meta: meta)
        end
      end
    end
  end
end
