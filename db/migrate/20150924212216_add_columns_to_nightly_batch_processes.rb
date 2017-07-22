class AddColumnsToNightlyBatchProcesses < ActiveRecord::Migration
  def change
  	add_column :nightly_batch_processes, :processed, :string,limit: 1
  end
end
