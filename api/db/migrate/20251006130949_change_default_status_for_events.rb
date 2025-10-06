class ChangeDefaultStatusForEvents < ActiveRecord::Migration[8.0]
  def change
    change_column_default :events, :status, from: 0, to: 4
  end
end
