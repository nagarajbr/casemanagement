class TblWorkTasksRefIntegrity < ActiveRecord::Migration
  def change
  	 execute <<-SQL
    	ALTER TABLE work_tasks
		ADD CONSTRAINT work_tasks_client_id_fkey
		    FOREIGN KEY (client_id)
		    REFERENCES clients(id);
     SQL

      execute <<-SQL
      	CREATE INDEX index_work_tasks_on_client_id
		  ON work_tasks
		  USING btree
		  (client_id);
      SQL
  end
end
