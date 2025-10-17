class JwtService
  ALGORITHM = "HS256"
  ACCESS_TTL = 1.days
  REFRESH_TTL = 7.days

  class ExpiredToken < StandardError; end
  class InvalidToken < StandardError; end

  def self.secret_key
    ENV.fetch("JWT_SECRET_KEY")
  end

  def self.encode(payload, exp:)
    body = payload.dup.symbolize_keys
    body[:exp] = exp.to_i
    JWT.encode(body, secret_key, ALGORITHM)
  end

  def self.decode(token)
    decoded, = JWT.decode(token, secret_key, true, { algorithm: ALGORITHM })
    decoded.with_indifferent_access
  rescue JWT::ExpiredSignature
    raise Api::Errors::AuthError::ExpiredToken
  rescue JWT::DecodeError, JWT::VerificationError
    raise Api::Errors::AuthError::InvalidToken
  end

  def self.issue_tokens_for(user)
    now = Time.current
    jti = SecureRandom.uuid
    access = encode({ sub: user.id, typ: "access", jti: jti }, exp: now + ACCESS_TTL)
    refresh = encode({ sub: user.id, typ: "refresh", jti: jti }, exp: now + REFRESH_TTL)

    { access_token: access, refresh_token: refresh }
  end
end
