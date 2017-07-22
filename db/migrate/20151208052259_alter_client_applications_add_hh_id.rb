class AlterClientApplicationsAddHhId < ActiveRecord::Migration
  def change
  	add_column :client_applications, :household_id, :integer
  end
end
