class TblApplicationServiceProgramsRefIntegrity < ActiveRecord::Migration
  def change
	  	execute <<-SQL
	    	ALTER TABLE application_service_programs
			ADD CONSTRAINT application_service_programs_client_application_id_fkey
			    FOREIGN KEY (client_application_id)
			    REFERENCES client_applications(id);
	    SQL

	    execute <<-SQL
	    	ALTER TABLE application_service_programs
			ADD CONSTRAINT application_service_programs_service_program_id_fkey
			    FOREIGN KEY (service_program_id)
			    REFERENCES service_programs(id);
	    SQL
	end
end
