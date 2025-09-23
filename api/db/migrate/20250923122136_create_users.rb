class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name, null: false, limit: 64
      t.string :email, null: false, limit: 128
      t.string :password_digest, null: false, limit: 64
      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
