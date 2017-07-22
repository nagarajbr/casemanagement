class TblProgramBenefitDetailsRefIntegrity < ActiveRecord::Migration
  def change
  	 execute <<-SQL
  		ALTER TABLE program_wizards
		ADD CONSTRAINT program_wizards_run_id_month_seq_unique UNIQUE (run_id,month_sequence);
	SQL
  end
end
