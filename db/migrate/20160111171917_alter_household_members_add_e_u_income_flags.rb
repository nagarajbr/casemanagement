class AlterHouseholdMembersAddEUIncomeFlags < ActiveRecord::Migration
  def change
  		add_column :household_members, :earned_income_flag, "char(1)"
  		add_column :household_members, :unearned_income_flag, "char(1)"
  end
end
