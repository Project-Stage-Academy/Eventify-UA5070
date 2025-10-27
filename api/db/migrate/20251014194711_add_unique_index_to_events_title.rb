class AddUniqueIndexToEventsTitle < ActiveRecord::Migration[8.0]
  def change
    add_index :events, :title, unique: true
  end
end
