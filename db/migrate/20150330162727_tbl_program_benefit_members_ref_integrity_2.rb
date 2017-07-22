class TblProgramBenefitMembersRefIntegrity2 < ActiveRecord::Migration
  def change

  	 change_column :program_benefit_details, :run_id, :integer, null:false
  	 change_column :program_benefit_details, :month_sequence, :integer, null:false
  	 change_column :program_benefit_details, :program_wizard_id, :integer, null:false



  	 execute <<-SQL
    	ALTER TABLE program_benefit_details
		ADD CONSTRAINT program_benefit_details_program_wizard_id_fkey
		    FOREIGN KEY (program_wizard_id)
		    REFERENCES program_wizards(id);
     SQL

      execute <<-SQL
      	CREATE INDEX index_program_benefit_details_on_program_wizard_id
		  ON program_benefit_details
		  USING btree
		  (program_wizard_id);
      SQL

       execute <<-SQL
    	ALTER TABLE program_benefit_details
		ADD CONSTRAINT program_benefit_details_run_id_mnth_seq_fkey
		    FOREIGN KEY (run_id,month_sequence)
		    REFERENCES program_wizards(run_id,month_sequence);
     SQL

      execute <<-SQL
      	CREATE INDEX index_program_benefit_details_on_run_id_mnth_seq
		  ON program_benefit_details
		  USING btree
		  (run_id,month_sequence);
      SQL

  end
end
