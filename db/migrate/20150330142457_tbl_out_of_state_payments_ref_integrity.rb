class TblOutOfStatePaymentsRefIntegrity < ActiveRecord::Migration
  def change
  	change_column :out_of_state_payments, :client_id, :integer, null:false
  	change_column :out_of_state_payments, :payment_month, :date, null:false

  	 execute <<-SQL
    	ALTER TABLE out_of_state_payments
		ADD CONSTRAINT out_of_state_payments_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
     SQL

      execute <<-SQL
      	CREATE INDEX index_out_of_state_payments_on_client_id
		  ON out_of_state_payments
		  USING btree
		  (client_id);
      SQL
  end
end
