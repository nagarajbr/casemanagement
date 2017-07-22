class AlterTableClientApplications < ActiveRecord::Migration
  def change
  	add_column :client_applications, :application_processor , :integer
  end
end
