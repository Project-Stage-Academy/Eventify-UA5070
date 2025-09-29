module Authenticatable
  extend ActiveSupport::Concern

  attr_reader :current_user

  def authorize_request
    header = request.headers["Authorization"].to_s
    token = header[/\ABearer\s+/i] ? header.split(" ", 2).last : nil

    if token.blank?
      raise Api::Errors::AuthError::MissingBearerToken
    end

    payload = JwtService.decode(token)
    @current_user = User.includes(:roles).find(payload[:sub])
  rescue ActiveRecord::RecordNotFound
    raise Api::Errors::UserError::NotFound
  end

  def require_role!(*role_names)
    roles = role_names.flatten.compact.map!(&:to_sym)

    allowed =
      current_user.present? &&
      (roles.empty? || roles.any? { |role| current_user.has_role?(role) })

    unless allowed
      raise Api::Errors::CommonError::Forbidden
    end
  end
end
