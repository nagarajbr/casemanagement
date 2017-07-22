class CreateApplicationMembers < ActiveRecord::Migration
  def change
    create_table :application_members do |t|
    	t.references :client_application, index: true, null: false
    	t.references :client, index: true, null: false
    	t.integer :member_status, null: false
    	t.string  :primary_member_flag, limit: 1, null: false
    	t.integer :created_by , null:false
    	t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
