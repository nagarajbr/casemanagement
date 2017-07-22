class AlterTableProvider3 < ActiveRecord::Migration
  def up
  	remove_column :providers, :provider_phone_number
  	remove_column :providers, :provider_phone_extension
  end
end
