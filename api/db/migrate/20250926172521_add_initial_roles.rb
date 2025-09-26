class AddInitialRoles < ActiveRecord::Migration[8.0]
  def change
    Role.create(name: "USER")
    Role.create(name: "ADMIN")
  end
end
