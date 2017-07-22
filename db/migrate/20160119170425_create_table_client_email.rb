class CreateTableClientEmail < ActiveRecord::Migration
  def change
    create_table :client_emails do |t|
    	t.references :client, index: true
    	t.string  :email_address , null:false
  		t.integer :created_by , null:false
  		t.integer :updated_by , null:false
    	t.timestamps
    end
  end
end