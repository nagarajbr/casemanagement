class CreateClientActivityServices < ActiveRecord::Migration
  def change
    create_table :client_activity_services do |t|
    	t.integer :client_activity_id,null: false
    	 t.integer :service_type,null: false
    	 t.integer :created_by , null:false
    	 t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
