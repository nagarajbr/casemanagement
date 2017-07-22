class CreateActivityHours < ActiveRecord::Migration
  def change
    create_table :activity_hours do |t|
      t.references :action_plan_detail, index: true
      t.references :client, index: true
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
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
