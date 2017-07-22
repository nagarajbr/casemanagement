class TblClientParentalRspabilitiesRefIntegrity < ActiveRecord::Migration
  def change
  	 execute <<-SQL
    	ALTER TABLE client_parental_rspabilities
		ADD CONSTRAINT cl_p_r_client_relationship_id_fkey
		    FOREIGN KEY (client_relationship_id)
		    REFERENCES client_relationships(id);
      SQL
  end
end
