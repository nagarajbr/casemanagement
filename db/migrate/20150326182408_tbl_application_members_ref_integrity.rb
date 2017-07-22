class TblApplicationMembersRefIntegrity < ActiveRecord::Migration
  def change
  	# 1.referential integrity
  	 execute <<-SQL
    	ALTER TABLE application_members
		ADD CONSTRAINT app_member_client_application_id_fkey
		    FOREIGN KEY (client_application_id)
		    REFERENCES client_applications(id);
        SQL

     # 2.referential integrity
      execute <<-SQL
    	ALTER TABLE application_members
		ADD CONSTRAINT app_member_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
        SQL

      # 3. unique constraints - application_id & client_id combination is unique
       execute <<-SQL
  			ALTER TABLE application_members
			ADD CONSTRAINT app_member_app_id_and_client_id_unique UNIQUE (client_application_id,client_id);
	   SQL

  end
end
