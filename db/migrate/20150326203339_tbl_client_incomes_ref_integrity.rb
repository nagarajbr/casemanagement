class TblClientIncomesRefIntegrity < ActiveRecord::Migration
  def change
  		change_column :client_incomes, :client_id, :integer, null:false
  		change_column :client_incomes, :income_id, :integer, null:false

  		# 1.
  		execute <<-SQL
    		ALTER TABLE client_incomes
			ADD CONSTRAINT cl_incomes_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
        SQL

        # 2.
        execute <<-SQL
    		ALTER TABLE client_incomes
			ADD CONSTRAINT cl_incomes_income_id_fkey
		    FOREIGN KEY (income_id)
		    REFERENCES incomes(id);
        SQL
  end
end
