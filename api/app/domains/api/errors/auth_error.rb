module Api
  module Errors
    module AuthError
      class InvalidCredentials < BaseError
        def initialize(meta: nil, **)
          super(code: :"auth.invalid_credentials", status: :unauthorized, meta: meta)
        end
      end

      class MissingBearerToken < BaseError
        def initialize(meta: nil, **)
          super(code: :"auth.missing_bearer_token", status: :unauthorized, meta: meta)
        end
      end

      class ExpiredToken < BaseError
        def initialize(meta: nil, **)
          super(code: :"auth.expired_token", status: :unauthorized, meta: meta)
        end
      end

      class InvalidToken < BaseError
        def initialize(meta: nil, **)
          super(code: :"auth.invalid_token", status: :unauthorized, meta: meta)
        end
      end

      class DefaultRoleMissing < BaseError
        def initialize(role:, meta: nil, **)
          super(
            code:   :"auth.default_role_missing",
            status: :unprocessable_entity,
            meta:   (meta || {}).merge(role: role),
            i18n:   { role: role }
          )
        end
      end
    end
  end
end
