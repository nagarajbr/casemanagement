class CreateWorkTasksVersions < ActiveRecord::Migration
  def change
    create_table :work_tasks_versions do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.json     :object
      t.json     :object_changes
      t.datetime :created_at
    end
    add_index :work_tasks_versions, [:item_type, :item_id]
  end
end
