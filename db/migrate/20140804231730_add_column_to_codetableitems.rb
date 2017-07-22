class AddColumnToCodetableitems < ActiveRecord::Migration
  def up
  	 add_column :codetable_items, :parent_id, :integer
  	  add_column :codetable_items, :parent_type, :string
  end

  def down
  	 remove_column :codetable_items, :parent_id
  	 remove_column :codetable_items, :parent_type
  end
end
