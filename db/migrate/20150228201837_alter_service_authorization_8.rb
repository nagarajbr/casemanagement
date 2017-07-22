class AlterServiceAuthorization8 < ActiveRecord::Migration
  def change
  	remove_column :service_authorizations, :activity_service_id
  end
end
