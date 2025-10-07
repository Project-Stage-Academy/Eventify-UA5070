class CreateEventMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :event_members do |t|
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :ticket_qr_code, null: false
      t.integer :rating, limit: 2
      t.check_constraint "rating IS NULL OR rating BETWEEN 1 AND 5", name: "rating_range"
      t.text :comment

      t.timestamps
    end

    add_index :event_members, :ticket_qr_code, unique: true
    add_index :event_members, [ :event_id, :rating ],
              where: "rating IS NOT NULL",
              name: "index_rated_event_members_by_event"
  end
end
