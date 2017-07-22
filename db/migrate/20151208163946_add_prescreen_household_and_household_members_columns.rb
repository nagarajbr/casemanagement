class AddPrescreenHouseholdAndHouseholdMembersColumns < ActiveRecord::Migration
  def change
  	add_column :prescreen_households, :ui_benefit_amount, :decimal, precision: 8, scale: 2
  	add_column :prescreen_household_members, :pregnancy_flag, :string, limit: 1
  	add_column :prescreen_household_members, :attending_school, :integer
  	add_column :prescreen_household_members, :caretaker_flag, :string, limit: 1
  end

end
