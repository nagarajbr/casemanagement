class AlterHouseholdMembersAddFields < ActiveRecord::Migration
  def change
  		add_column :household_members, :state, :integer
  		add_column :household_members, :current_step_url, :string
  end
end
