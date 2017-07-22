class AlterHouseholdMembersAddEducationFlag < ActiveRecord::Migration
  def change
  	add_column :household_members, :education_add_flag, "char(1)"
  	add_column :household_members, :income_add_flag, "char(1)"
  	add_column :household_members, :expense_add_flag, "char(1)"
  	add_column :household_members, :resource_add_flag, "char(1)"
  end
end
