module Authenticatable
  extend ActiveSupport::Concern

  included do
    rescue_from JwtService::ExpiredToken do |e| render json: { error: e.message }, status: :unauthorized end
    rescue_from JwtService::InvalidToken do |e| render json: { error: e.message }, status: :unauthorized end
    rescue_from ActiveRecord::RecordNotFound do
      render json: { error: "User not found" }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  def authorize_request
    header = request.headers["Authorization"].to_s
    token = header.start_with?("Bearer") ? header.split(" ", 2).last : nil
    raise JwtService::InvalidToken, "Missing bearer token" if token.blank?

    payload = JwtService.decode(token)
    @current_user = User.find(payload[:sub])
  end

  def require_role!(*role_names)
    unless current_user&.roles&.exists?(name: role_names)
      render json: { error: "Forbidden" }, status: :forbidden
    end
  end
end
