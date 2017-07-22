class AlterActionPlansCppSnapshot3 < ActiveRecord::Migration
  def change
  	add_column :action_plan_cpp_snapshots, :parent_primary_key_id, :integer
  end
end
