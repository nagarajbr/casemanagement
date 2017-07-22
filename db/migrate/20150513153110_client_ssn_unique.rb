class ClientSsnUnique < ActiveRecord::Migration
  def change
  	 execute <<-SQL
  		ALTER TABLE clients
		ADD CONSTRAINT clients_ssn_unique UNIQUE (ssn);
	SQL
  end
end
