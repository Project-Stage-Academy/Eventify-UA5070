class ApplicationController < ActionController::API
  include ErrorRendering
  include Authenticatable
  include Pundit::Authorization

  before_action :authorize_request
end
