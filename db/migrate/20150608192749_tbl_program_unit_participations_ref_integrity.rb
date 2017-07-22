class TblProgramUnitParticipationsRefIntegrity < ActiveRecord::Migration
  	def change
	  	execute <<-SQL
	    	ALTER TABLE program_unit_participations
			ADD CONSTRAINT program_unit_participations_program_unit_id_fkey
			    FOREIGN KEY (program_unit_id)
			    REFERENCES program_units(id);
	    SQL
	end
end
