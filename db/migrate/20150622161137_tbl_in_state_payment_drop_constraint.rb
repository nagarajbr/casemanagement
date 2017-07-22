class TblInStatePaymentDropConstraint < ActiveRecord::Migration
  def change
  	execute <<-SQL
    	ALTER TABLE in_state_payments
		DROP CONSTRAINT in_state_payments_program_unit_id_fkey;
	SQL
  end
end