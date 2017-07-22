class TblClientNotesRefIntegrity < ActiveRecord::Migration
  def change
  	 execute <<-SQL
    	ALTER TABLE client_notes
		ADD CONSTRAINT client_notes_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
      SQL
  end
end
