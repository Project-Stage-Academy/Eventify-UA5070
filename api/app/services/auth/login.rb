module Auth
  class Login
    def self.call!(params, token_issuer: JwtService)
      new(params, token_issuer).call!
    end

    def initialize(params, token_issuer)
      @email = params[:email].to_s.strip.downcase
      @password = params[:password]
      @token_issuer = token_issuer
    end

    def call!
      user = User.find_by(email: @email)

      if user&.authenticate(@password)
        @token_issuer.issue_tokens_for(user)
      else
        raise Api::Errors::AuthError::InvalidCredentials
      end
    end
  end
end
