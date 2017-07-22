class AlterInStatePayments < ActiveRecord::Migration
  def up
     remove_column :in_state_payments, :category
     add_column :in_state_payments, :service_program_id, :integer
 end
end
