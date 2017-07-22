class TblClientResourcesRefIntegrity < ActiveRecord::Migration
  def change
  	 execute <<-SQL
    	ALTER TABLE client_resources
		ADD CONSTRAINT cl_resources_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
     SQL

      execute <<-SQL
    	ALTER TABLE client_resources
		ADD CONSTRAINT cl_resources_resource_id_fkey
		    FOREIGN KEY (resource_id)
		    REFERENCES resources(id);
     SQL

      execute <<-SQL
      	CREATE INDEX index_cl_resources_on_client_id
		  ON client_resources
		  USING btree
		  (client_id);
      SQL

       execute <<-SQL
      	CREATE INDEX index_cl_resources_on_resource_id
		  ON client_resources
		  USING btree
		  (resource_id);
      SQL

      execute <<-SQL
  			ALTER TABLE client_resources
			ADD CONSTRAINT cl_resources_client_id_and_resource_id_unique UNIQUE (client_id,resource_id);
		SQL


  end
end
