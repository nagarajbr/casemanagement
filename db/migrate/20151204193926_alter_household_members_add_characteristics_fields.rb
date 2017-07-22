class AlterHouseholdMembersAddCharacteristicsFields < ActiveRecord::Migration
  def change
  	add_column :household_members, :general_health_chalng_to_work_charcteristics_found_add_flag, "char(1)"
  	add_column :household_members, :disability_charcteristics_found_add_flag, "char(1)"
  	add_column :household_members, :mental_health_issues_charcteristics__found_add_flag, "char(1)"
  	add_column :household_members, :substnce_abuse_issues_charcteristics_found_add_flag, "char(1)"
  	add_column :household_members, :domestic_violence_issues_charcteristics_found_add_flag, "char(1)"
  	add_column :household_members, :legal_issues_charcteristics_found_add_flag, "char(1)"
  	add_column :household_members, :pregnancy_charcteristics_found_add_flag, "char(1)"
  end
end






