module Auth
  class Register
    def self.call!(params, token_issuer: JwtService)
      new(params, token_issuer).call!
    end

    def initialize(params, token_issuer)
      @params = params
      @token_issuer = token_issuer
    end

    def call!
      user = nil
      normalized_params = @params.merge(email: @params[:email].to_s.downcase.strip)

      if User.exists?(email: normalized_params[:email])
        raise Api::Errors::UserError::EmailTaken
      end

      ActiveRecord::Base.transaction do
        user = User.new(normalized_params)
        user.save!
        user.add_role!(Role::NAMES[:user])
      end

      tokens = @token_issuer.issue_tokens_for(user)

      { user: user, tokens: tokens }
    rescue ActiveRecord::RecordInvalid => e
      raise Api::Errors::CommonError::InvalidParams.new(meta: { errors: e.record.errors.to_hash })
    end
  end
end
