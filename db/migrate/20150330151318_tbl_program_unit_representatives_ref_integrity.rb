class TblProgramUnitRepresentativesRefIntegrity < ActiveRecord::Migration
  def change
  		change_column :program_unit_representatives, :representative_type, :integer, null:false

  		 execute <<-SQL
    	ALTER TABLE program_unit_representatives
		ADD CONSTRAINT program_unit_representatives_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
     SQL

      execute <<-SQL
    	ALTER TABLE program_unit_representatives
		ADD CONSTRAINT program_unit_representatives_program_unit_id_fkey
		    FOREIGN KEY (program_unit_id)
		    REFERENCES program_units(id);
     SQL

  end
end
