class AddNewColumnToProviderService < ActiveRecord::Migration
  def change
  	  add_column :provider_services, :occupation, "varchar(255)"
  end
end
