class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
    	t.integer :school_type , null:false
    	t.string :school_name, null:false
    	t.string :web_address, limit: 100
    	t.string :email_address, limit: 50
    	t.string :contact_notes

      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
