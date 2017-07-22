class TblClientIncomesIndexes < ActiveRecord::Migration
  def change
  	  execute <<-SQL
      	CREATE INDEX index_cl_incomes_on_client_id
		  ON client_incomes
		  USING btree
		  (client_id);
      SQL

        execute <<-SQL
      	CREATE INDEX index_cl_incomes_on_income_id
		  ON client_incomes
		  USING btree
		  (income_id);
      SQL
  end
end
