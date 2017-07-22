class CreateActivityHourCppSnapshots < ActiveRecord::Migration
  def change
    create_table :activity_hour_cpp_snapshots do |t|
    	t.integer :career_pathway_plan_id, null:false
    	t.integer :action_plan_detail_id
    	t.integer :client_id
    	t.date :activity_date
    	t.integer :work_participation_code
    	t.integer :assigned_hours
    	t.integer :completed_hours
    	t.integer :completed_minutes
    	t.integer :absent_hours
    	t.integer :absent_minutes
    	t.integer :absent_reason
    	t.integer :time_limit
    	t.boolean :caretaker_flag


    	 t.integer :activity_hour_created_by
    	 t.integer :activity_hour_updated_by
    	 t.timestamp :activity_hour_created_at
    	 t.timestamp :activity_hour_updated_at
    	 t.integer :created_by, null:false
      	 t.integer :updated_by, null:false
      t.timestamps
    end
  end
end

