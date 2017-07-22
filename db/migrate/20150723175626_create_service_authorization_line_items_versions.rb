class CreateServiceAuthorizationLineItemsVersions < ActiveRecord::Migration
  def change
    create_table :seriz_auth_line_items_versions do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.json     :object
      t.json     :object_changes
      t.datetime :created_at
    end
    add_index :seriz_auth_line_items_versions, [:item_type, :item_id]
  end
end
