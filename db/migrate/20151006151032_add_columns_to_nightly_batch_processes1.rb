class AddColumnsToNightlyBatchProcesses1 < ActiveRecord::Migration
  def change
  	add_column :nightly_batch_processes, :run_month, :date
  	add_column :nightly_batch_processes, :submit_flag, :string,limit: 1
  end
end