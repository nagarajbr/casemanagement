class TblClientRacesRefIntegrity < ActiveRecord::Migration
  def change
  	change_column :client_races, :client_id, :integer, null:false
  	change_column :client_races, :race_id, :integer, null:false

  	 execute <<-SQL
    	ALTER TABLE client_races
		ADD CONSTRAINT client_races_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
     SQL

  end
end
