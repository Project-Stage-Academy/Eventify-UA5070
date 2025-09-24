module Api
  module V1
    class AuthController < BaseController
      skip_before_action :authorize_request, only: %i[register login]

      def register
        user = User.new(register_params)

        if user.save
          user.roles << Role.find_by!(name: "USER")
          tokens = JwtService.issue_tokens_for(user)
          render json: {
            access_token: tokens[:access_token],
            refresh_token: tokens[:refresh_token],
            user: {
              id: user.id,
              name: user.name,
              email: user.email,
              roles: user.roles.select(:id, :name)
            }
          }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def login
        user = User.find_by("LOWER(email) = ?", login_params[:email].to_s.downcase)

        if user&.authenticate(login_params[:password])
          tokens = JwtService.issue_tokens_for(user)
          render json: {
            access_token: tokens[:access_token],
            refresh_token: tokens[:refresh_token]
          }, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      private

      def register_params
        params.require(:name)
        params.require(:email)
        params.require(:password)
        params.permit(:name, :email, :password)
      end

      def login_params
        params.require(:email)
        params.require(:password)
        params.permit(:email, :password)
      end
    end
  end
end
