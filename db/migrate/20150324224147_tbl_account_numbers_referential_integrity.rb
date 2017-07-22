class TblAccountNumbersReferentialIntegrity < ActiveRecord::Migration
	# Manoj 03/24/2015 - referential Integrity,index & not null constraints
  def change

  	change_column :account_numbers, :account_number, :integer, null:false
  	change_column :account_numbers, :representative_id, :integer, null:false

  	 execute <<-SQL
    	ALTER TABLE account_numbers
		ADD CONSTRAINT account_number_representative_id_fkey
		    FOREIGN KEY (representative_id)
		    REFERENCES program_unit_representatives(id);
        SQL

      execute <<-SQL
      	CREATE INDEX index_account_numbers_on_representative_id
		  ON account_numbers
		  USING btree
		  (representative_id);
      SQL

  end
end
