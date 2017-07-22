class AlterPrescreenHouseholdMembersTable1 < ActiveRecord::Migration
  def up
  	add_column :prescreen_household_members, :relation_to_primary_member, :integer
  end
end
