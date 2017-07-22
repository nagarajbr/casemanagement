class AlterProvidersTable1 < ActiveRecord::Migration
  def change
  	change_column :providers, :provider_physical_address_line1, :string, null:true
  	change_column :providers, :provider_physical_city, :string, null:true
  	change_column :providers, :provider_physical_state, :integer, null:true
  	change_column :providers, :provider_physical_postal_code, :integer, null:true
  	change_column :providers, :provider_mailing_address_line1, :string, null:true
  	change_column :providers, :provider_mailing_city, :string, null:true
  	change_column :providers, :provider_mailing_state, :string, null:true
  	change_column :providers, :provider_mailing_postal_code, :integer, null:true
  	change_column :providers, :provider_phone_number, :string, limit: 10
  end
end
