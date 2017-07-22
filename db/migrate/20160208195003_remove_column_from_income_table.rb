class RemoveColumnFromIncomeTable < ActiveRecord::Migration
  def change
  	remove_column :incomes, :position_type
  end
end
