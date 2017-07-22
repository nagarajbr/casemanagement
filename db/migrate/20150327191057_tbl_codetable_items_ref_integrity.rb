class TblCodetableItemsRefIntegrity < ActiveRecord::Migration
  def change

  	change_column :codetable_items, :code_table_id, :integer, null:false
  	change_column :codetable_items, :short_description, :string, null:false
  	 execute <<-SQL
    	ALTER TABLE codetable_items
		ADD CONSTRAINT codetable_items_code_table_id_fkey
		    FOREIGN KEY (code_table_id)
		    REFERENCES code_tables(id);
     SQL
  end
end
