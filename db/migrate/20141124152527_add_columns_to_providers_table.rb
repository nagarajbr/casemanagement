class AddColumnsToProvidersTable < ActiveRecord::Migration
  def up
  	add_column :providers, :aasis_verified_status, :integer
	add_column :providers, :aasis_verified_date, :date
  end
end
