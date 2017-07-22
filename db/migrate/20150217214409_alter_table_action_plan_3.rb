class AlterTableActionPlan3 < ActiveRecord::Migration
  def change
  	change_column :action_plans, :employment_readiness_plan_id, :integer, null:false
  end
end
