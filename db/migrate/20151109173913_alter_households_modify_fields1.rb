class AlterHouseholdsModifyFields1 < ActiveRecord::Migration
  def change
  	rename_column :households, :state, :registration_status
  end
end
