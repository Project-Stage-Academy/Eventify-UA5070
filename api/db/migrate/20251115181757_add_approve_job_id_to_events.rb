class AddApproveJobIdToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :approve_job_id, :integer
  end
end
