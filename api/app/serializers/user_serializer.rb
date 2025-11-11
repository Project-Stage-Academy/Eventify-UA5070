class UserSerializer < Blueprinter::Base
  identifier :id
  fields :name, :email

  association :roles, blueprint: RoleSerializer
end
