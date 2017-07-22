class AlterPrescreenHouseholdMembersTable4 < ActiveRecord::Migration
  def up
  	add_column :prescreen_household_members, :pra_accept, :string, limit: 1
  end
end
