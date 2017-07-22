class AddColumnToProviderServiceAreasTable3 < ActiveRecord::Migration
  def up
  	add_column :provider_service_areas, :local_office_id , :integer, null:false
  end
end
