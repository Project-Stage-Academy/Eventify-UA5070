class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string  :title, null: false
      t.text    :description
      t.string  :location, null: false
      t.st_point :coordinates, geographic: true
      t.datetime :start_date, null: false
      t.datetime :finish_date
      t.integer :participant_capacity
      t.decimal :ticket_price, precision: 10, scale: 2, default: 0.0
      t.check_constraint "ticket_price >= 0", name: "ticket_price_non_negative"
      t.integer :status, default: 0
      t.references :organizer, type: :uuid, foreign_key: { to_table: :users }, null: false

      t.timestamps
    end

    add_index :events, :start_date
    add_index :events, :coordinates, using: :gist

    # add_index :events, [:location, :start_date]
    # Good for precise city searches. If we plan on partial names, the index is not helpful.
  end
end
