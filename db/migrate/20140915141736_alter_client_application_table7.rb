class AlterClientApplicationTable7 < ActiveRecord::Migration
  def up
  	remove_column :client_applications, :registered_date
  end
end
