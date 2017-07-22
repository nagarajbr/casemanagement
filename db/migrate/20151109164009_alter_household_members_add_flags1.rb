class AlterHouseholdMembersAddFlags1 < ActiveRecord::Migration
  def change
  		add_column :household_members, :member_status, :integer
  		add_column :household_members, :ethnicity_add_flag, "char(1)"
  		add_column :household_members, :citizenship_add_flag, "char(1)"
  		add_column :household_members, :contacts_add_flag, "char(1)"
  end
end
