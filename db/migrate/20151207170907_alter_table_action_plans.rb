class AlterTableActionPlans < ActiveRecord::Migration
  def up
  	add_column :action_plans, :short_term_goal, :string
  	add_column :action_plans, :long_term_goal, :string
  end

  def down
  	remove_column :action_plans, :short_term_goal
  	remove_column :action_plans, :long_term_goal
  end
end
