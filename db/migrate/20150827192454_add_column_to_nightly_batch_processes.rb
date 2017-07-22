class AddColumnToNightlyBatchProcesses < ActiveRecord::Migration
  def change
  	add_column :nightly_batch_processes, :client_id, :integer
  end
end
