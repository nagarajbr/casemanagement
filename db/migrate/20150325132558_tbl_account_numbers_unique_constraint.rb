class TblAccountNumbersUniqueConstraint < ActiveRecord::Migration
  def change
  	 execute <<-SQL
  		ALTER TABLE account_numbers
		ADD CONSTRAINT account_number_representative_id_unique UNIQUE (account_number,representative_id);
	SQL
  end
end
