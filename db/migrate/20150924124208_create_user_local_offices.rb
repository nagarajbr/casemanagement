class CreateUserLocalOffices < ActiveRecord::Migration
  def change
    create_table :user_local_offices do |t|
    	t.references :user , null:false
    	t.integer :local_office_id, null:false
       t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
