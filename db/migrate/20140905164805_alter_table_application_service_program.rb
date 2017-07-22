class AlterTableApplicationServiceProgram < ActiveRecord::Migration
  def up
  	 change_column :application_service_programs, :status, 'integer USING CAST(status AS integer)'
  end
end
