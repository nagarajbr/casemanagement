class TblEmploymentsRefIntegrity < ActiveRecord::Migration
  def change
  	 execute <<-SQL
    	ALTER TABLE employments
		ADD CONSTRAINT employments_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
     SQL


  end
end
