class TblClientBarriersRefIntegrity < ActiveRecord::Migration
  def change
	  	execute <<-SQL
	    	ALTER TABLE client_barriers
			ADD CONSTRAINT client_barriers_client_id_fkey
			    FOREIGN KEY (client_id)
			    REFERENCES clients(id);
	    SQL
	end
end
