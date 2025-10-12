class RefactorEventModel < ActiveRecord::Migration[8.0]
  def change
    rename_column :events, :event_status, :status
    remove_column :events, :review_status, :integer

    add_column :events, :proposed_title, :string, limit: 128
    add_column :events, :proposed_desc, :text
    add_column :events, :proposed_location, :geography, limit: { srid: 4326, type: "st_point", geographic: true }
  end
end
