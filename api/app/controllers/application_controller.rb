class ApplicationController < ActionController::API
  include ErrorRendering
  include Authenticatable
  include Pundit::Authorization
  include ParamValidation

  before_action :authorize_request
end
