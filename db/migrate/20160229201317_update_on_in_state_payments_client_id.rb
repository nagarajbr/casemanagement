class UpdateOnInStatePaymentsClientId < ActiveRecord::Migration
  def change
  	change_column :in_state_payments, :client_id, :integer, null:true
  end
end
