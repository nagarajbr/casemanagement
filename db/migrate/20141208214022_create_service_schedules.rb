class CreateServiceSchedules < ActiveRecord::Migration
  def change
    create_table :service_schedules do |t|
      t.references :service_authorization, index: true, null: false
      t.integer :trip_day,null: false
      t.time :trip_pick_up_time
	  t.time :return_trip_pick_up_time
	  t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
