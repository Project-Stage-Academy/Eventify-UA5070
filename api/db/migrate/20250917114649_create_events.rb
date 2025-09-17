class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string  :title, null: false
      t.text    :description
      t.string  :location, null: false
      t.datetime :start_date, null: false
      t.datetime :finish_date
      t.integer :participant_capacity
      t.decimal :ticket_price, precision: 10, scale: 2
      t.string  :status, default: "draft"
      t.references :organizer, type: :uuid, foreign_key: { to_table: :users }, null: true

      t.timestamps
    end

    add_index :events, :start_date
    add_index :events, :location
  end
end
