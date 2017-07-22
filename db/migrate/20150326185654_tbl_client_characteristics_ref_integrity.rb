class TblClientCharacteristicsRefIntegrity < ActiveRecord::Migration
  def change

  	change_column :client_characteristics, :characteristic_id, :integer, null:false

  	 execute <<-SQL
    	ALTER TABLE client_characteristics
		ADD CONSTRAINT client_characteristic_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
     SQL

  end
end
