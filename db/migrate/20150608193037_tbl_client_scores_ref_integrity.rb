class TblClientScoresRefIntegrity < ActiveRecord::Migration
  def change
	  	execute <<-SQL
	    	ALTER TABLE client_scores
			ADD CONSTRAINT client_scores_client_id_fkey
			    FOREIGN KEY (client_id)
			    REFERENCES clients(id);
	    SQL
	end
end
