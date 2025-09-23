class ApplicationController < ActionController::API
  include Authenticatable

  before_action :authorize_request
end
