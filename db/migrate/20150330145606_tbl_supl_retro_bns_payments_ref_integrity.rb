class TblSuplRetroBnsPaymentsRefIntegrity < ActiveRecord::Migration
  def change
  	change_column :supl_retro_bns_payments, :program_unit_id, :integer, null:false
  	change_column :supl_retro_bns_payments, :payment_type, :integer, null:false
  	change_column :supl_retro_bns_payments, :payment_month, :date, null:false
  	change_column :supl_retro_bns_payments, :payment_amount, :decimal, precision: 8, scale: 2, null:false

  	 execute <<-SQL
    	ALTER TABLE supl_retro_bns_payments
		ADD CONSTRAINT supl_retro_bns_payments_program_unit_id_id_fkey
		    FOREIGN KEY (program_unit_id)
		    REFERENCES program_units(id);
     SQL

  end
end
