class CreateWorkQueueLocalOfficeSubscriptions < ActiveRecord::Migration
  def change
    create_table :work_queue_local_office_subscriptions do |t|
    		t.integer :local_office_id , null:false
    		t.integer :queue_type , null:false
    		t.integer :created_by , null:false
    		t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
