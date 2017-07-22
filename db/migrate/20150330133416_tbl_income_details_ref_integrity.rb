class TblIncomeDetailsRefIntegrity < ActiveRecord::Migration
  def change
  	change_column :income_details, :income_id, :integer, null:false
  	change_column :income_details, :check_type, :integer, null:false
  	change_column :income_details, :date_received, :date, null:false

  	execute <<-SQL
    	ALTER TABLE income_details
		ADD CONSTRAINT incm_dtl_income_id_fkey
		    FOREIGN KEY (income_id)
		    REFERENCES incomes(id);
     SQL

  end
end
