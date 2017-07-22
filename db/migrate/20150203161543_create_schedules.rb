class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :entity
      t.integer :reference_id
      t.integer :day_of_week, array:true
      t.time :time_of_day
      t.integer :duration
      t.integer :recurring
      t.integer :created_by , null:false
	  t.integer :updated_by , null:false
      t.timestamps
    end
  end
end


