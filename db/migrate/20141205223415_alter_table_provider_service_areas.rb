class AlterTableProviderServiceAreas < ActiveRecord::Migration
  def up
  	add_column :provider_service_areas, :served_county, :integer
  	change_column :provider_service_areas, :area_zip,:string, null:true
  end
end
