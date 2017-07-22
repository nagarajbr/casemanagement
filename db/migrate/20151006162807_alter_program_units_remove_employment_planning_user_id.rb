class AlterProgramUnitsRemoveEmploymentPlanningUserId < ActiveRecord::Migration
  def up
  	 remove_column :program_units, :employment_planning_user_id
  end

  def down
  	add_column :program_units, :employment_planning_user_id, :integer
  end
end
