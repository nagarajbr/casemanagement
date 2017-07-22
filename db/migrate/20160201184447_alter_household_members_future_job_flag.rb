class AlterHouseholdMembersFutureJobFlag < ActiveRecord::Migration
  def change
  	add_column :household_members, :job_offer_flag, "char(1)"
  end
end
