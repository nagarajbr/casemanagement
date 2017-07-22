class AlterHouseholdMembersChangeFieldNames < ActiveRecord::Migration
  def change
  		rename_column :household_members, :state, :registration_status
  		rename_column :household_members, :current_step_url, :current_step_partial
  end
end
