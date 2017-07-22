class CreateServiceAuthorizationLineItems < ActiveRecord::Migration
  def change
    create_table :service_authorization_line_items do |t|
    	t.integer :service_authorization_id,null: false
    	t.date    :service_date, null: false
    	t.time :service_begin_time
	  	t.time :service_end_time
    	t.string :trip_start_address_line1, limit: 50
	    t.string :trip_start_address_line2, limit: 50
	    t.string :trip_start_address_city, limit: 50
	    t.integer :trip_start_address_state
	    t.string :trip_start_address_zip, limit: 5
      	t.string :trip_end_address_line1, limit: 50
      	t.string :trip_end_address_line2, limit: 50
      	t.string :trip_end_address_city, limit: 50
      	t.integer :trip_end_address_state
      	t.string :trip_end_address_zip, limit: 5
      	t.integer :quantity
      	t.integer :unit_of_measure
      	t.decimal :estimated_cost, precision: 8, scale: 2
      	t.decimal :actual_cost, precision: 8, scale: 2
      	t.string :override_reason
      	t.integer :status
      	t.string :provider_invoice
      	t.text :notes
      	t.integer :created_by , null:false
      	t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
