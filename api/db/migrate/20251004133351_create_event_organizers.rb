class CreateEventOrganizers < ActiveRecord::Migration[8.0]
  def change
    create_table :event_organizers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end

    add_index :event_organizers, [:event_id, :user_id], unique: true
  end
end
