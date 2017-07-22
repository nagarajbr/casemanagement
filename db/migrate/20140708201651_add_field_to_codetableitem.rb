class AddFieldToCodetableitem < ActiveRecord::Migration
  def up
    add_column :codetable_items, :active, :boolean

  end
end
