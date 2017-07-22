class AlterProgramUnitsAddWorkFlowColumns < ActiveRecord::Migration
  def change
  	add_column :program_units, :work_flow_status, :integer
  	add_column :program_units, :requested_by, :integer
  	add_column :program_units, :requested_date, :datetime
  	add_column :program_units, :approved_by, :integer
  	add_column :program_units, :approved_date, :datetime
  	add_column :program_units, :rejected_by, :integer
  	add_column :program_units, :rejected_date, :datetime
  	add_column :program_units, :rejection_reason, :integer
  	add_column :program_units, :rejection_comments, :string


  end
end
