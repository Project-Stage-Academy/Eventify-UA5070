module Api
  module V1
    class UsersController < BaseController
      before_action -> { require_role!(Role::NAMES[:user]) }, only: :me

      def me
        render json: UserSerializer.render_as_hash(current_user), status: :ok
      end
    end
  end
end
