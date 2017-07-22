class TblDataValidationsRefIntegrity < ActiveRecord::Migration
  def change
  	 execute <<-SQL
    	ALTER TABLE data_validations
		ADD CONSTRAINT data_validations_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
     SQL

       execute <<-SQL
      	CREATE INDEX index_data_validations_on_client_id
		  ON data_validations
		  USING btree
		  (client_id);
      SQL
  end
end
