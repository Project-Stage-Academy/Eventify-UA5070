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
    meta = {}
    meta[:query] = exception.query if exception.respond_to?(:query)
    meta[:record] = exception.record if exception.respond_to?(:record)

    render_api_error(Api::Errors::CommonError::Forbidden.new(meta: meta.presence))
  end
end
