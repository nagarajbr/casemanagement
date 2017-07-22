class TblExpensesNotNullConstraints < ActiveRecord::Migration
  def change
  		change_column :expenses, :effective_beg_date, :date, null:false
  end
end
