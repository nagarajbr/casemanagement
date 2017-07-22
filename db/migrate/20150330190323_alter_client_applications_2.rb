class AlterClientApplications2 < ActiveRecord::Migration
  def change
  	 remove_column :client_applications, :application_processing_county
  end
end
