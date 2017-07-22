class AlterTableProviderColumns < ActiveRecord::Migration
   def up
  	change_column :providers, :provider_name,:string,limit: 50
  	change_column :providers, :contact_person,:string,limit: 50
  	change_column :providers, :tax_id_ssn,:string,limit: 12
  	change_column :providers, :provider_physical_address_line1,:string,limit: 50
  	change_column :providers, :provider_physical_address_line2,:string,limit: 50
  	change_column :providers, :provider_physical_address_line3,:string,limit: 50
  	change_column :providers, :provider_physical_city,:string,limit: 50
  	rename_column :providers, :provider_physical_postal_code, :provider_physical_zip
  	rename_column :providers, :provider_physical_zip_4, :provider_physical_zip_suffix
  	change_column :providers, :provider_mailing_address_line1,:string,limit: 50
  	change_column :providers, :provider_mailing_address_line2,:string,limit: 50
  	change_column :providers, :provider_mailing_address_line3,:string,limit: 50
  	change_column :providers, :provider_mailing_city,:string,limit: 50
  	rename_column :providers, :provider_mailing_postal_code, :provider_mailing_zip
  	rename_column :providers, :provider_mailing_zip_4, :provider_mailing_zip_suffix
  	change_column :providers, :license_number,:string,limit: 20
  	change_column :providers, :email_address,:string,limit: 50
  	change_column :providers, :web_address,:string,limit: 100
  end
end
