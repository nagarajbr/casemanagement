class CreateProgramUnitTaskOwners < ActiveRecord::Migration
  def change
    create_table :program_unit_task_owners do |t|
    	t.integer :program_unit_id, null:false
    	t.integer :ownership_type, null:false
    	t.integer :ownership_user_id, null:false
    	t.integer :created_by , null:false
        t.integer :updated_by , null:false
        t.timestamps
    end
  end
end


