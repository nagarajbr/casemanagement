class CreateClientApplications < ActiveRecord::Migration
  def change
    create_table :client_applications do |t|
		
    	t.date :application_date, null: false
		t.integer :application_status, null: false
		t.integer :application_disposition_status
		t.integer :application_disposition_reason
		t.integer :application_origin
		t.integer :application_processing_county
    t.references :client, index: true
		t.integer :created_by , null:false
    	t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
