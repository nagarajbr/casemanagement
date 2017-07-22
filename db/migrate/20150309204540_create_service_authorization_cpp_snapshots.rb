class CreateServiceAuthorizationCppSnapshots < ActiveRecord::Migration
  def change
    create_table :service_authorization_cpp_snapshots do |t|
    	t.integer :career_pathway_plan_id,null:false
    	t.integer :parent_primary_key_id,null:false
    	t.integer :provider_id,null:false
    	t.integer :program_unit_id,null:false
    	t.integer :client_id,null:false
    	t.date :service_start_date
    	t.date :service_end_date
    	t.string :trip_start_address_line1,limit: 50
    	t.string :trip_start_address_line2,limit: 50
    	t.string :trip_start_address_city,limit: 50
    	t.integer :trip_start_address_state
    	t.string :trip_start_address_zip,limit: 5
    	t.string :trip_end_address_line1,limit: 50
    	t.string :trip_end_address_line2,limit: 50
    	t.string :trip_end_address_city,limit: 50
    	t.integer :trip_end_address_state
    	t.string :trip_end_address_zip,limit: 5
    	t.integer :outcome_achieved
    	t.integer :status
    	t.integer :service_type
    	t.string :supportive_service_flag,limit: 1
    	t.date :service_date
    	t.integer :action_plan_detail_id
    	t.integer :barrier_id
    	t.text :notes
    	t.date :client_agreement_date
    	t.integer :service_authorization_created_by,null:false
    	t.integer :service_authorization_updated_by,null:false
    	t.timestamp :service_authorization_created_at,null:false
      	t.timestamp :service_authorization_updated_at,null:false
      	t.integer :created_by,null:false
      	t.integer :updated_by,null:false

      t.timestamps
    end
  end
end


