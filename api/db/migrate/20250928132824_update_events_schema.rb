class UpdateEventsSchema < ActiveRecord::Migration[8.0]
  def change
    if column_exists?(:events, :status)
      remove_column :events, :status
    end

    add_column :events, :event_status, :integer, default: 0, null: false

    add_column :events, :review_status, :integer, default: 0, null: false
    add_column :events, :review_comment, :text

    add_check_constraint :events, "participant_capacity >= 0", name: "participant_capacity_non_negative"
  end
end
