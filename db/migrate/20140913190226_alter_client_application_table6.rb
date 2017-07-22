class AlterClientApplicationTable6 < ActiveRecord::Migration
  def up
  	remove_column :client_applications, :client_id
  	
  end
end
