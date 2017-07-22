class AlterClientApplicationTable8 < ActiveRecord::Migration
  def up
  	add_column :client_applications, :application_received_office, :integer
  	
  end
end
