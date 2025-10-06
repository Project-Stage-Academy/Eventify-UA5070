module JsonErrorRendering
  extend ActiveSupport::Concern

  def render_json_error(message:, status: :unprocessable_entity)
    render json: { errors: Array(message) }, status: status
  end
end
