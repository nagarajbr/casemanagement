class TblApplicationEligibilityResultsRefIntegrity < ActiveRecord::Migration
  def change
  	# 1.
  	 execute <<-SQL
    	ALTER TABLE application_eligibility_results
		ADD CONSTRAINT app_elgblty_rslts_application_id_fkey
		    FOREIGN KEY (application_id)
		    REFERENCES client_applications(id);
        SQL

     # 2.
      execute <<-SQL
      	CREATE INDEX index_app_elgblty_rslts_on_application_id
		  ON application_eligibility_results
		  USING btree
		  (application_id);
      SQL

      # 3.
       execute <<-SQL
    	ALTER TABLE application_eligibility_results
		ADD CONSTRAINT app_elgblty_rslts_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
        SQL

      # 4.
       execute <<-SQL
      	CREATE INDEX index_app_elgblty_rslts_on_client_id
		  ON application_eligibility_results
		  USING btree
		  (client_id);
      SQL


  end
end
