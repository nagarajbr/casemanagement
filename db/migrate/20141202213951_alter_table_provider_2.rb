class AlterTableProvider2 < ActiveRecord::Migration
  def up
  	remove_column :providers, :provider_physical_address_line1
  	remove_column :providers, :provider_physical_address_line2
  	remove_column :providers, :provider_physical_address_line3
  	remove_column :providers, :provider_physical_city
  	remove_column :providers, :provider_physical_state
  	remove_column :providers, :provider_physical_zip
  	remove_column :providers, :provider_physical_zip_suffix
  	remove_column :providers, :provider_mailing_address_line1
  	remove_column :providers, :provider_mailing_address_line2
  	remove_column :providers, :provider_mailing_address_line3
  	remove_column :providers, :provider_mailing_city
  	remove_column :providers, :provider_mailing_state
  	remove_column :providers, :provider_mailing_zip
  	remove_column :providers, :provider_mailing_zip_suffix
  end
end




