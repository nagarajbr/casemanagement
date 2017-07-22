class AlterProgramUnitsAddPlanningUserId < ActiveRecord::Migration
  def change
  	add_column :program_units, :employment_planning_user_id, :integer
  end
end
