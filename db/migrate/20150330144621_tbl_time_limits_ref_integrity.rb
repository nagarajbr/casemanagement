class TblTimeLimitsRefIntegrity < ActiveRecord::Migration
  def change
  	 execute <<-SQL
    	ALTER TABLE time_limits
		ADD CONSTRAINT time_limits_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
     SQL


  end
end
