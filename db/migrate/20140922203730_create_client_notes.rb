class CreateClientNotes < ActiveRecord::Migration
  def change
    create_table :client_notes do |t|
    	t.references :client, index: true, null:false
    	t.integer :notes_type,null:false
    	t.string :notes
    	t.integer :created_by , null:false
    	t.integer :updated_by , null:false
    end
  end
end
