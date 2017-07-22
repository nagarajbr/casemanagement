class DropUnusedTables1 < ActiveRecord::Migration
  def change
  	# drop_table :table_name
  	drop_table :client_activities
  	drop_table :client_activities_versions
  	drop_table :client_activity_services
  	drop_table :client_actvty_servc_versions
  end
end
