class AddIsPrimaryToEventOrganizers < ActiveRecord::Migration[8.0]
  def change
    add_column :event_organizers, :is_primary, :boolean, default: false, null: false
  end
end
