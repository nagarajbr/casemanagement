class AlterTableEmployer2 < ActiveRecord::Migration
  def change
  	change_column :employers, :federal_ein, :string, limit: 9
  	change_column :employers, :state_ein, :string, limit: 12
  end
end
