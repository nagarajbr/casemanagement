class TblEligibilityDetermineResultsRefIntegrity < ActiveRecord::Migration
  def change
  	# program wizards Table -start
  	change_column :program_wizards, :run_id, :integer, null:false
  	change_column :program_wizards, :month_sequence, :integer, null:false
  	change_column :program_wizards, :run_month, :date, null:false

  	 execute <<-SQL
    	ALTER TABLE program_wizards
		ADD CONSTRAINT program_wizards_program_unit_id_fkey
		    FOREIGN KEY (program_unit_id)
		    REFERENCES program_units(id);
     SQL

     execute <<-SQL
  			ALTER TABLE program_wizards
			ADD CONSTRAINT pg_wizard_run_id_and_month_sequence_unique UNIQUE (run_id,month_sequence);
		SQL

		# program wizards Table -end

		# eligibility_determine_results -start

  	 execute <<-SQL
    	ALTER TABLE eligibility_determine_results
		ADD CONSTRAINT elg_det_results_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
     SQL

     execute <<-SQL
    	ALTER TABLE eligibility_determine_results
		ADD CONSTRAINT elg_det_results_program_unit_id_fkey
		    FOREIGN KEY (program_unit_id)
		    REFERENCES program_units(id);
     SQL

      execute <<-SQL
    	ALTER TABLE eligibility_determine_results
		ADD CONSTRAINT elg_det_results_run_id_month_sequence_fkey
		    FOREIGN KEY (run_id,month_sequence)
		    REFERENCES program_wizards(run_id,month_sequence);
     SQL


       execute <<-SQL
      	CREATE INDEX index_elg_det_results_on_client_id
		  ON eligibility_determine_results
		  USING btree
		  (client_id);
      SQL

       execute <<-SQL
      	CREATE INDEX index_elg_det_results_on_program_unit_id
		  ON eligibility_determine_results
		  USING btree
		  (program_unit_id);
      SQL

      # eligibility_determine_results -end

  end
end
