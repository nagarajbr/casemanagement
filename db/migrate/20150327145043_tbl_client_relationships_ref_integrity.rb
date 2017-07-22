class TblClientRelationshipsRefIntegrity < ActiveRecord::Migration
  def change

  	 execute <<-SQL
    	ALTER TABLE client_relationships
		ADD CONSTRAINT cl_relationships_from_client_id_fkey
		    FOREIGN KEY (from_client_id)
		    REFERENCES clients(id);
     SQL

      execute <<-SQL
    	ALTER TABLE client_relationships
		ADD CONSTRAINT cl_relationships_to_client_id_fkey
		    FOREIGN KEY (to_client_id)
		    REFERENCES clients(id);
     SQL

      execute <<-SQL
      	CREATE INDEX index_cl_relationships_on_from_client_id
		  ON client_relationships
		  USING btree
		  (from_client_id);
      SQL

       execute <<-SQL
      	CREATE INDEX index_cl_relationships_on_to_client_id
		  ON client_relationships
		  USING btree
		  (to_client_id);
      SQL


  		execute <<-SQL
  			ALTER TABLE client_relationships
			ADD CONSTRAINT cl_relationships_from_cl_and_relationship_type_and_to_cl_unique UNIQUE (from_client_id,relationship_type,to_client_id);
		SQL
  end
end
