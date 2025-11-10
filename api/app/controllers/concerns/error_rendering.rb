module ErrorRendering
  extend ActiveSupport::Concern

  included do
    rescue_from Api::Errors::BaseError, with: :render_api_error
    rescue_from Pundit::NotAuthorizedError, with: :render_forbidden
  end

  private

  def render_api_error(error)
    title = I18n.t("errors.#{error.code}", default: error.message)
    render json: {
      error: {
        code: error.code.to_s,
        title: title,
        detail: title,
        meta: error.meta
      }
    }, status: error.status
  end

  def render_forbidden(exception)
    render_api_error(Api::Errors::CommonError::Forbidden.new)
  end
end
