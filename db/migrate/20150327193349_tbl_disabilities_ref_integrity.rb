class TblDisabilitiesRefIntegrity < ActiveRecord::Migration
  def change

  	change_column :disabilities, :disiability_type, :integer, null:false

  	 execute <<-SQL
    	ALTER TABLE disabilities
		ADD CONSTRAINT disabilities_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
     SQL


  end
end
