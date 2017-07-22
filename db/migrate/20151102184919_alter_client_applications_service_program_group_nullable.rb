class AlterClientApplicationsServiceProgramGroupNullable < ActiveRecord::Migration
  def change
  		  	change_column :client_applications, :service_program_group, :integer, null:true
  end
end
