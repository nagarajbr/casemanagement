class TblExpenseDetailsRefIntegrity < ActiveRecord::Migration
  def change

  	change_column :expense_details, :expense_id, :integer, null:false
  	change_column :expense_details, :expense_amount, :decimal, precision: 8, scale: 2, null:false

  	 execute <<-SQL
    	ALTER TABLE expense_details
		ADD CONSTRAINT expense_details_expense_id_fkey
		    FOREIGN KEY (expense_id)
		    REFERENCES expenses(id);
     SQL



  end
end
