module Api
  module V1
    class UsersController < BaseController
      before_action -> { require_role!("USER") }, only: :me

      def me
        render json: {
          id: current_user.id,
          name: current_user.name,
          email: current_user.email,
          roles: current_user.roles.select(:id, :name)
        }, status: :ok
      end
    end
  end
end
