class CreatePrimaryContacts < ActiveRecord::Migration
  def change
    create_table :primary_contacts do |t|
    	t.integer :entity_id , null:false
  		t.integer :entity_type , null:false
  		t.integer :client_id , null:false
  		t.integer :created_by , null:false
  		t.integer :updated_by , null:false
    	t.timestamps
    end
  end
end
