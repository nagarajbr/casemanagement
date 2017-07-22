class AlterHouseholdMembersTableAddStepsCompleted < ActiveRecord::Migration
  def change
  		add_column :household_members, :steps_completed, :string
  end
end
