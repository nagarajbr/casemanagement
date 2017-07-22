class AddColumnsToActionPlanDetails < ActiveRecord::Migration
  def change
  	add_column :action_plan_details, :child_id, :integer
  	add_column :action_plan_details, :child_dob, :date
  end
end
