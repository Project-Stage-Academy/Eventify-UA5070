module Api
  module V1
    module Admin
      class AdminBaseController < ApplicationController
        include Serialization

        before_action :authorize_admin!

        def authorize_admin!
          render json: { error: "Access denied" }, status: :forbidden unless current_user.has_role?(:admin)
        end
      end
    end
  end
end
