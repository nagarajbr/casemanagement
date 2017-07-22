class CreateAllTypeColumnToCodetableitems < ActiveRecord::Migration
def up
    add_column :codetable_items, :type, :string
end
end


