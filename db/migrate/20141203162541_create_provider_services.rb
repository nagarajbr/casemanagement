class CreateProviderServices < ActiveRecord::Migration
  def change
    create_table :provider_services do |t|
    	t.references :provider, index: true, null: false
	    t.integer :service_type, null: false
	    t.integer :service_units
	    t.date :start_date, null: false
	    t.date :end_date
	    t.integer :created_by , null:false
	    t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
