class TblEducationsRefIntegrity < ActiveRecord::Migration
  def change
  	 execute <<-SQL
    	ALTER TABLE educations
		ADD CONSTRAINT educations_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
     SQL
  end
end
