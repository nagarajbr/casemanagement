class TblProgramMonthSummariesRefIntegrity < ActiveRecord::Migration
  def change
  		 change_column :program_month_summaries, :run_id, :integer, null:false
  		 change_column :program_month_summaries, :month_sequence, :integer, null:false
  		 change_column :program_month_summaries, :program_wizard_id, :integer, null:false

  		  execute <<-SQL
    	ALTER TABLE program_month_summaries
		ADD CONSTRAINT program_month_summaries_program_wizard_id_fkey
		    FOREIGN KEY (program_wizard_id)
		    REFERENCES program_wizards(id);
     SQL

      execute <<-SQL
      	CREATE INDEX index_program_month_summaries_on_program_wizard_id
		  ON program_month_summaries
		  USING btree
		  (program_wizard_id);
      SQL

       execute <<-SQL
    	ALTER TABLE program_month_summaries
		ADD CONSTRAINT program_month_summaries_run_id_mnth_seq_fkey
		    FOREIGN KEY (run_id,month_sequence)
		    REFERENCES program_wizards(run_id,month_sequence);
     SQL

      execute <<-SQL
      	CREATE INDEX index_program_month_summaries_on_run_id_mnth_seq
		  ON program_month_summaries
		  USING btree
		  (run_id,month_sequence);
      SQL
  end
end
