class AlterClientApplicationTable2 < ActiveRecord::Migration
  def up
  	remove_column :client_applications, :wizard_step
  end
end
