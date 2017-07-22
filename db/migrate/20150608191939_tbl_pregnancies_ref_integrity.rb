class TblPregnanciesRefIntegrity < ActiveRecord::Migration
  def change
  	execute <<-SQL
    	ALTER TABLE pregnancies
		ADD CONSTRAINT pregnancies_clients_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
     SQL
  end
end
