class AlterProgramUnitRemoveColumns < ActiveRecord::Migration
  def change
  		remove_column :program_units, :work_flow_status
  		remove_column :program_units, :approved_by
  		remove_column :program_units, :approved_date
  		remove_column :program_units, :rejected_by
  		remove_column :program_units, :rejected_date
  		remove_column :program_units, :rejection_reason
  		remove_column :program_units, :rejection_comments
  		add_column :program_units, :disposed_by, :integer
  		change_column :program_units, :disposition_date, "datetime"
  end
end
