class AlterClientApplicationTable3 < ActiveRecord::Migration
  def up
  	 change_column :client_applications, :client_id, :integer, null:false
  end
end
