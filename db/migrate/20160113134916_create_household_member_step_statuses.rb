class CreateHouseholdMemberStepStatuses < ActiveRecord::Migration
  def change
    create_table :household_member_step_statuses do |t|
    	t.references :client, index: true,null:false
    	t.integer :step
      	t.string  :complete_flag , limit: 1
      	t.string :step_partial
      	t.integer :household_id
        t.timestamps
    end
  end
end





