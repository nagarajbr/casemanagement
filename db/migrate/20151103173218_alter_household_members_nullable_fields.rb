class AlterHouseholdMembersNullableFields < ActiveRecord::Migration
  def change
  	change_column :household_members, :household_member_role, :integer, null:true
  	change_column :household_members, :household_participation_status, :integer, null:true
  	change_column :household_members, :household_participation_date, :date, null:true
  	add_column :household_members, :head_of_household_flag, "char(1)"


  end
end
