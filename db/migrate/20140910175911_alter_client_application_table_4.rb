class AlterClientApplicationTable4 < ActiveRecord::Migration
  def up
  	add_column :client_applications, :service_program_group, :integer, null: false
  end
end
