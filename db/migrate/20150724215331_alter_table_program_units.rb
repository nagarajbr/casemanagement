class AlterTableProgramUnits < ActiveRecord::Migration
  def change
  	rename_column :program_units, :work_flow_status, :state
  	rename_column :program_units, :work_flow_rejection_reason, :reason
  	remove_column :program_units, :requested_by
  	remove_column :program_units, :requested_date
  	remove_column :program_units, :work_flow_updated_date
  	remove_column :program_units, :work_flow_updated_by
  end
end
