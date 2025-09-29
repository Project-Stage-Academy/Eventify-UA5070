module Api
  module V1
    class AuthController < BaseController
      skip_before_action :authorize_request, only: %i[register login]

      def register
        result = Auth::Register.call!(register_params)

        render json: {
          access_token: result[:tokens][:access_token],
          refresh_token: result[:tokens][:refresh_token],
          user: UserSerializer.new(result[:user])
        }, status: :created
      end

      def login
        tokens = Auth::Login.call!(login_params)

        render json: tokens, status: :ok
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
