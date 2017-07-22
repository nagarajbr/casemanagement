class AlterProgramUnitsAddWorkflowFields < ActiveRecord::Migration
  def change

  		add_column :program_units, :work_flow_status, :integer
  		add_column :program_units, :work_flow_updated_by, :integer
  		add_column :program_units, :work_flow_updated_date, :datetime

  		add_column :program_units, :work_flow_rejection_reason, :string
  end
end
