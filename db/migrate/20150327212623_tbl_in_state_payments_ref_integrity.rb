class TblInStatePaymentsRefIntegrity < ActiveRecord::Migration
  def change
  	change_column :in_state_payments, :program_unit_id, :integer, null:false
  	change_column :in_state_payments, :client_id, :integer, null:false
  	change_column :in_state_payments, :payment_month, :date, null:false
  	change_column :in_state_payments, :dollar_amount, :decimal, precision: 8, scale: 2, null:false
  	change_column :in_state_payments, :payment_type, :integer, null:false


  	 execute <<-SQL
    	ALTER TABLE in_state_payments
		ADD CONSTRAINT in_state_payments_program_unit_id_fkey
		    FOREIGN KEY (program_unit_id)
		    REFERENCES program_units(id);
     SQL

      execute <<-SQL
    	ALTER TABLE in_state_payments
		ADD CONSTRAINT in_state_payments_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
     SQL

      execute <<-SQL
  		ALTER TABLE in_state_payments
		ADD CONSTRAINT in_st_paymnt_client_id_payment_month_payment_type_unique UNIQUE (client_id,payment_month,payment_type);
	SQL

	 execute <<-SQL
      	CREATE INDEX index_in_state_payments_on_program_unit_id
		  ON in_state_payments
		  USING btree
		  (program_unit_id);
      SQL

      execute <<-SQL
      	CREATE INDEX index_in_state_payments_on_client_id
		  ON in_state_payments
		  USING btree
		  (client_id);
      SQL



  end
end
