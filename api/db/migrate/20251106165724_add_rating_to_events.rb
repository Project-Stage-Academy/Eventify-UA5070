class AddRatingToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :average_rating, :decimal, precision: 2, scale: 1
    add_column :events, :rating_count, :integer, default: 0, null: false

    add_index :events, :average_rating
  end
end
