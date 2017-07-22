class TblProgramBenefitMembersRefIntegrity < ActiveRecord::Migration
  def change

  	 change_column :program_benefit_members, :run_id, :integer, null:false
  	 change_column :program_benefit_members, :month_sequence, :integer, null:false
  	 change_column :program_benefit_members, :member_sequence, :integer, null:false

  	  execute <<-SQL
  		ALTER TABLE program_benefit_members
		ADD CONSTRAINT pbm_run_id_month_seq_mem_seq_unique UNIQUE (run_id,month_sequence,member_sequence);
	SQL


  	 execute <<-SQL
    	ALTER TABLE program_benefit_members
		ADD CONSTRAINT program_benefit_members_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
     SQL

     execute <<-SQL
    	ALTER TABLE program_benefit_members
		ADD CONSTRAINT program_benefit_members_program_wizard_id_fkey
		    FOREIGN KEY (program_wizard_id)
		    REFERENCES program_wizards(id);
     SQL

      execute <<-SQL
      	CREATE INDEX index_program_benefit_members_on_client_id
		  ON program_benefit_members
		  USING btree
		  (client_id);
      SQL

  end
end
