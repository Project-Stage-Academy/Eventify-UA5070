class ApplicationController < ActionController::API
  include ErrorRendering
  include Authenticatable

  before_action :authorize_request
end
