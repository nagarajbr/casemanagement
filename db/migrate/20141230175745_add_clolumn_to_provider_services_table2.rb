class AddClolumnToProviderServicesTable2 < ActiveRecord::Migration
  def up
	add_column :provider_services, :local_office_id , :integer, null:false
  end
end
