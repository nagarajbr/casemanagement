class CreateWorkQueues < ActiveRecord::Migration
  def change
    create_table :work_queues do |t|
    	t.integer :state , null:false
        t.integer :reference_type , null:false
        t.integer :reference_id , null:false
        t.integer :created_by , null:false
        t.integer :updated_by , null:false
      t.timestamps

    end
  end
end
