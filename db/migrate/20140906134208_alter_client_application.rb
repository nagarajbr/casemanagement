class AlterClientApplication < ActiveRecord::Migration
  def up
  	add_column :client_applications, :wizard_step, :integer
  end
end
