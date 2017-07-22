class AddCoreHoursToActionPlanTable < ActiveRecord::Migration
  def change
  		add_column :action_plans, :core_hours, :integer
    	add_column :action_plans, :non_core_hours, :integer
  end
end
