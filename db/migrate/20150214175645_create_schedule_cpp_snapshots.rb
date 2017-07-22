class CreateScheduleCppSnapshots < ActiveRecord::Migration
  def change
    create_table :schedule_cpp_snapshots do |t|
    	t.integer :career_pathway_plan_id, null:false
    	t.integer :entity
    	t.integer :reference_id
    	t.integer :day_of_week, array:true
    	t.time :time_of_day
    	t.integer :duration
    	t.integer :recurring
    	 t.integer :action_plan_schedule_created_by
    	 t.integer :action_plan_schedule_updated_by
    	 t.timestamp :action_plan_schedule_created_at
    	 t.timestamp :action_plan_schedule_updated_at
    	 t.integer :created_by, null:false
      	 t.integer :updated_by, null:false

      t.timestamps
    end
  end
end


