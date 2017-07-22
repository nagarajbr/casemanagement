class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string  :alert_text
      t.integer :alert_category,null:false
      t.integer :alert_type
      t.integer :alert_for_type
	   t.integer :alert_for_id
	   t.integer :alert_assigned_to_user_id
	   t.date :expiration_date
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
