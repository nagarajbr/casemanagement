class TblProgramUnitMembersRefIntegrity < ActiveRecord::Migration
  def change
  	change_column :program_unit_members, :client_id, :integer, null:false

  	 execute <<-SQL
  		ALTER TABLE program_unit_members
		ADD CONSTRAINT pgu_pgu_id_client_id_unique UNIQUE (program_unit_id,client_id);
	SQL

	 execute <<-SQL
    	ALTER TABLE program_unit_members
		ADD CONSTRAINT program_unit_members_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
     SQL

      execute <<-SQL
    	ALTER TABLE program_unit_members
		ADD CONSTRAINT program_unit_members_program_unit_id_fkey
		    FOREIGN KEY (program_unit_id)
		    REFERENCES program_units(id);
     SQL

      execute <<-SQL
      	CREATE INDEX index_program_unit_members_on_client_id
		  ON program_unit_members
		  USING btree
		  (client_id);
      SQL

  end
end
