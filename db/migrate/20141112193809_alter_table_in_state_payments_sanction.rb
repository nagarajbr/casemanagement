class AlterTableInStatePaymentsSanction < ActiveRecord::Migration
  def up
  	change_column :in_state_payments, :sanction, 'integer USING CAST(sanction AS integer)'
  	change_column :in_state_payments, :category, 'integer USING CAST(category AS integer)'
  	remove_column :in_state_payments, :action_type
  	add_column :in_state_payments, :action_type, :integer
  end
end
