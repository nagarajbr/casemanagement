class TblProgramMemberDetailsRefIntegrity < ActiveRecord::Migration
  def change
  	 change_column :program_member_details, :run_id, :integer, null:false
  	 change_column :program_member_details, :month_sequence, :integer, null:false
  	 change_column :program_member_details, :member_sequence, :integer, null:false

  	    execute <<-SQL
    	ALTER TABLE program_member_details
		ADD CONSTRAINT program_member_details_run_id_mnth_seq_mem_seq_fkey
		    FOREIGN KEY (run_id,month_sequence,member_sequence)
		    REFERENCES program_benefit_members(run_id,month_sequence,member_sequence);
     SQL

      execute <<-SQL
      	CREATE INDEX index_program_member_details_on_run_id_mnth_seq_mem_seq
		  ON program_member_details
		  USING btree
		  (run_id,month_sequence,member_sequence);
      SQL

  end
end
