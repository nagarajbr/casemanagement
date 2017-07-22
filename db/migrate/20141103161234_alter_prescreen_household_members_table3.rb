class AlterPrescreenHouseholdMembersTable3 < ActiveRecord::Migration
  def up
  		add_column :prescreen_household_members, :middle_name, :string, limit: 35
  		add_column :prescreen_household_members, :suffix, :string, limit: 4
  		add_column :prescreen_household_members, :ssn, :string, limit: 9
  		add_column :prescreen_household_members, :gender, :integer
  		add_column :prescreen_household_members, :marital_status, :integer
  		add_column :prescreen_household_members, :identification_type, :integer
  		add_column :prescreen_household_members, :primary_language, :integer
  end
end
