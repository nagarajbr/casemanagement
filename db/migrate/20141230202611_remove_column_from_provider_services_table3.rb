class RemoveColumnFromProviderServicesTable3 < ActiveRecord::Migration
  def change
  	remove_column :provider_services, :local_office_id
  end
end
