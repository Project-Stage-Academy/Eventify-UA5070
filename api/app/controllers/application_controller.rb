class ApplicationController < ActionController::API

  rescue_from ActiveRecord::RecordNotFound do |exception|
    model_name = exception.model || "Record"
    render json: { error: "#{model_name} not found" }, status: :not_found
  end

  include ErrorRendering
  include Authenticatable

  before_action :authorize_request
end
