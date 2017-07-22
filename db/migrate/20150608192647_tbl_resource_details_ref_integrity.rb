class TblResourceDetailsRefIntegrity < ActiveRecord::Migration
    def change
	  	execute <<-SQL
	    	ALTER TABLE resource_details
			ADD CONSTRAINT resource_details_resource_id_fkey
			    FOREIGN KEY (resource_id)
			    REFERENCES resources(id);
	    SQL
	end
end
