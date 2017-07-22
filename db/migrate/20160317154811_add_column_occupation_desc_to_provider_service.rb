class AddColumnOccupationDescToProviderService < ActiveRecord::Migration
  def change
  	add_column :provider_services, :occupation_desc, "varchar(255)"
  end
end
