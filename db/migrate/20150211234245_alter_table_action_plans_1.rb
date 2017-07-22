class AlterTableActionPlans1 < ActiveRecord::Migration
  def change
  	add_column :action_plans, :employment_readiness_plan_id, :integer
  end
end
