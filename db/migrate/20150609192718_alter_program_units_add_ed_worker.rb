class AlterProgramUnitsAddEdWorker < ActiveRecord::Migration
  def change
  	add_column :program_units, :eligibility_worker_id, :integer
  end
end
