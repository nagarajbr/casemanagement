class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|

    	t.integer :entity_type , null:false
    	t.integer :entity_id , null:false
    	t.integer :notes_type , null:false
    	t.string  :notes
		  t.integer :created_by , null:false
      t.integer :updated_by , null:false

      	t.timestamps
    end
  end
end
