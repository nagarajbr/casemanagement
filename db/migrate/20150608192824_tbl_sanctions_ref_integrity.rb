class TblSanctionsRefIntegrity < ActiveRecord::Migration
  def change
	  	execute <<-SQL
	    	ALTER TABLE sanctions
			ADD CONSTRAINT sanctions_client_id_fkey
			    FOREIGN KEY (client_id)
			    REFERENCES clients(id);
	    SQL

	    execute <<-SQL
	    	ALTER TABLE sanctions
			ADD CONSTRAINT sanctions_service_program_id_fkey
			    FOREIGN KEY (service_program_id)
			    REFERENCES service_programs(id);
	    SQL
	end
end
