class AddSortOrderToCodetableitems < ActiveRecord::Migration
  def change
  	add_column :codetable_items, :sort_order, :integer
  end
end
