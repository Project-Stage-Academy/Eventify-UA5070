# class UserSerializer
#   def initialize(user)
#     @user = user
#   end
#   я
#   def as_json(*)
#     {
#       id: @user.id,
#       name: @user.name,
#       email: @user.email,
#       roles: @user.roles.select(:id, :name).map { |role| { id: role.id, name: role.name } }
#     }
#   end
# end
class UserSerializer < Blueprinter::Base
  identifier :id
  fields :name, :email

  association :roles, blueprint: RoleSerializer
end
