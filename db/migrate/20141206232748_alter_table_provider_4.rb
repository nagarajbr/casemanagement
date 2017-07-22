class AlterTableProvider4 < ActiveRecord::Migration
  def up
  	rename_column :providers, :aasis_verified_status, :status
  	rename_column :providers, :aasis_verified_date, :status_date
  end
end
