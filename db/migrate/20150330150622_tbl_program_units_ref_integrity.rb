class TblProgramUnitsRefIntegrity < ActiveRecord::Migration
  def change
  	 execute <<-SQL
    	ALTER TABLE program_units
		ADD CONSTRAINT program_units_client_application_id_fkey
		    FOREIGN KEY (client_application_id)
		    REFERENCES client_applications(id);
     SQL
  end
end
