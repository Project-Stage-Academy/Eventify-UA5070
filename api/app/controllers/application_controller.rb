class ApplicationController < ActionController::API
  include ErrorRendering
  include Authenticatable
  include Pundit
  include ParamValidation

  before_action :authorize_request

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    render json: { error: I18n.t("errors.common.not_authorized") }, status: :forbidden
  end
end
