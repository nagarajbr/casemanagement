class CreateResourceUsesVersions < ActiveRecord::Migration
  def change
    create_table :resource_uses_versions do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.json     :object
      t.json     :object_changes
      t.datetime :created_at
    end
    add_index :resource_uses_versions, [:item_type, :item_id]

  end
end
