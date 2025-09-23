class CreateUserRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :user_roles, id: false, primary_key: %i[user_id role_id] do |t|
      t.references :user, null: false, foreign_key: true, index: false
      t.references :role, null: false, foreign_key: true, index: false
      t.timestamps
    end
    add_index :user_roles, %i[user_id role_id], unique: true
  end
end
