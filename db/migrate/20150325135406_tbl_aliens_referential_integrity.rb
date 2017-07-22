class TblAliensReferentialIntegrity < ActiveRecord::Migration
  def change
  	 execute <<-SQL
    	ALTER TABLE aliens
		ADD CONSTRAINT alien_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
        SQL


       execute <<-SQL
  			ALTER TABLE aliens
			ADD CONSTRAINT alien_client_id_unique UNIQUE (client_id);
	   SQL
  end
end
