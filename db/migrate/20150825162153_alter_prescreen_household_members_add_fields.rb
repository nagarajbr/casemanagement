class AlterPrescreenHouseholdMembersAddFields < ActiveRecord::Migration
  def change
  	add_column :prescreen_household_members, :disabled_flag, :string, limit: 1
  	add_column :prescreen_household_members, :veteran_flag, :string, limit: 1
  end
end


