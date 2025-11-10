module Api
  module Errors
    module AuthError
      BASE = :auth

      class InvalidCredentials < BaseError
        CODE = :"#{BASE}.invalid_credentials"

        def initialize(meta: nil, **)
          super(code: CODE, status: :unauthorized, meta: meta)
        end
      end

      class MissingBearerToken < BaseError
        CODE = :"#{BASE}.missing_bearer_token"

        def initialize(meta: nil, **)
          super(code: CODE, status: :unauthorized, meta: meta)
        end
      end

      class ExpiredToken < BaseError
        CODE = :"#{BASE}.expired_token"

        def initialize(meta: nil, **)
          super(code: CODE, status: :unauthorized, meta: meta)
        end
      end

      class InvalidToken < BaseError
        CODE = :"#{BASE}.invalid_token"

        def initialize(meta: nil, **)
          super(code: CODE, status: :unauthorized, meta: meta)
        end
      end

      class DefaultRoleMissing < BaseError
        CODE = :"#{BASE}.default_role_missing"

        def initialize(role:, meta: nil, **)
          super(
            code:   CODE,
            status: :unprocessable_entity,
            meta:   (meta || {}).merge(role: role),
            i18n:   { role: role }
          )
        end
      end
    end
  end
end
