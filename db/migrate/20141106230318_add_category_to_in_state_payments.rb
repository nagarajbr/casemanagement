class AddCategoryToInStatePayments < ActiveRecord::Migration
   def up
  	add_column :in_state_payments, :category, :string, limit: 2
  end
end
