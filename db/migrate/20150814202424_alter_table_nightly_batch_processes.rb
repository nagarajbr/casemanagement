class AlterTableNightlyBatchProcesses < ActiveRecord::Migration
  def change
  	add_column :nightly_batch_processes, :reason, :integer
  end
end
