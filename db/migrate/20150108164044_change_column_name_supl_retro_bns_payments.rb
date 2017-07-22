class ChangeColumnNameSuplRetroBnsPayments < ActiveRecord::Migration
  def change
  	rename_column :supl_retro_bns_payments, :program_units_id, :program_unit_id
  end
end
