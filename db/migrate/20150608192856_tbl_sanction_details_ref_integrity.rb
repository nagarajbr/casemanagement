class TblSanctionDetailsRefIntegrity < ActiveRecord::Migration
  def change
	  	execute <<-SQL
	    	ALTER TABLE sanction_details
			ADD CONSTRAINT sanction_details_sanction_id_fkey
			    FOREIGN KEY (sanction_id)
			    REFERENCES sanctions(id);
	    SQL
	end
end
