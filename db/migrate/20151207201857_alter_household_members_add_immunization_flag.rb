class AlterHouseholdMembersAddImmunizationFlag < ActiveRecord::Migration
  def change
  		add_column :household_members, :immunization_charcteristics_found_add_flag, "char(1)"
  end
end
