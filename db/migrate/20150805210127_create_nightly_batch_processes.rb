class CreateNightlyBatchProcesses < ActiveRecord::Migration
  def change
    create_table :nightly_batch_processes do |t|
      t.integer :entity_type, null: false
      t.integer :entity_id, null: false
      t.integer :process_type, null: false
      t.integer :sub_process_type
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
