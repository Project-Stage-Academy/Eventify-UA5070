class UsersController < ApplicationController
  before_action -> { require_role!("USER") }, only: :me

  def me
    render json: { id: current_user.id, name: current_user.name, email: current_user.email }
  end
end
