class AlterTableOutOfStatePaymentsTable1 < ActiveRecord::Migration
  def change
  	add_column :out_of_state_payments, :state, :integer
  end
end
