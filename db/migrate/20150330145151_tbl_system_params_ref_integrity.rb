class TblSystemParamsRefIntegrity < ActiveRecord::Migration
  def change
  	change_column :system_params, :system_param_categories_id, :integer, null:false
  	 execute <<-SQL
    	ALTER TABLE system_params
		ADD CONSTRAINT system_params_system_param_categories_id_fkey
		    FOREIGN KEY (system_param_categories_id)
		    REFERENCES system_param_categories(id);
     SQL
  end
end
