module Api
  module Errors
    module UserError
      class NotFound < BaseError
        def initialize(meta: nil, **)
          super(code: :"user.not_found", status: :not_found, meta: meta)
        end
      end

      class EmailTaken < BaseError
        def initialize(meta: nil, **)
          super(code: :"user.email_taken", status: :unprocessable_entity, meta: meta)
        end
      end
    end
  end
end
