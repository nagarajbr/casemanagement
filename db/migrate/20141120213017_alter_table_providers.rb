class AlterTableProviders < ActiveRecord::Migration
  def up
  	add_column :providers, :provider_pager_number, :integer
	add_column :providers, :w9_sign_date, :date
	add_column :providers, :notes, :string, limit: 255
  end
end
