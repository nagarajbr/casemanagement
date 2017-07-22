class TblClientRacesUniqueConstraints < ActiveRecord::Migration
  def change
  	execute <<-SQL
  		ALTER TABLE client_races
		ADD CONSTRAINT client_races_client_id_and_race_id_unique UNIQUE (client_id,race_id);
	SQL
  end
end
