class AlterTableServiceAuthorizations2 < ActiveRecord::Migration
  def change
  	rename_column :service_authorizations, :activity_id, :activity_service_id
  end
end
