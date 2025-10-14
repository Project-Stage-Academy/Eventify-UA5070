class ApplicationController < ActionController::API
  include ErrorRendering
  include Authenticatable
  include Pundit

  before_action :authorize_request
end
