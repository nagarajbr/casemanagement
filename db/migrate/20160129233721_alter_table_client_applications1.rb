class AlterTableClientApplications1 < ActiveRecord::Migration
  def change
  	change_column :client_applications, :application_processor, :string
  end
end
