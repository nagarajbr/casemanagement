class CreateProviderServiceAreaAvailabilities < ActiveRecord::Migration
  def change
    create_table :provider_service_area_availabilities do |t|
    	t.integer :provider_service_area_id, null: false
	    t.integer :day_of_the_week, null: false
	    t.time :start_time
	    t.time :end_time
	    t.integer :created_by , null:false
	    t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
