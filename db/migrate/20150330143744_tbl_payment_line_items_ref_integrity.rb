class TblPaymentLineItemsRefIntegrity < ActiveRecord::Migration
  def change
  	 execute <<-SQL
    	ALTER TABLE payment_line_items
		ADD CONSTRAINT payment_line_items_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
     SQL

      execute <<-SQL
      	CREATE INDEX index_payment_line_items_on_client_id
		  ON payment_line_items
		  USING btree
		  (client_id);
      SQL
  end
end
