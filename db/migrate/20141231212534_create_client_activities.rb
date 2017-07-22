class CreateClientActivities < ActiveRecord::Migration
  def change
    create_table :client_activities do |t|
    	 t.integer :program_unit_id,null: false
    	 t.integer :client_id,null: false
    	 t.integer :activity_type,null: false
    	 t.integer :created_by , null:false
    	 t.integer :updated_by , null:false

      t.timestamps
    end
  end
end
