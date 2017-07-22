class CreateWorkQueueUserSubscriptions < ActiveRecord::Migration
  def change
    create_table :work_queue_user_subscriptions do |t|
    	t.integer :user_id , null:false
    	t.integer :local_office_id , null:false
    	t.integer :queue_type , null:false
    	t.integer :created_by , null:false
    	t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
