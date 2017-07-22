class TblClientExpensesRefIntegrity < ActiveRecord::Migration
  def change
  		change_column :client_expenses, :client_id, :integer, null:false
  		change_column :client_expenses, :expense_id, :integer, null:false

  		# 1.
  		execute <<-SQL
    		ALTER TABLE client_expenses
			ADD CONSTRAINT cl_expenses_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
        SQL

        # 2.
        execute <<-SQL
    		ALTER TABLE client_expenses
			ADD CONSTRAINT cl_expenses_expense_id_fkey
		    FOREIGN KEY (expense_id)
		    REFERENCES expenses(id);
        SQL


  end
end
