class HhMemberDropFieldsRefIntegrity < ActiveRecord::Migration
  def change
  	remove_column :household_members, :current_step_partial
  	remove_column :household_members, :education_add_flag
  	remove_column :household_members, :expense_add_flag
  	remove_column :household_members, :resource_add_flag
  	remove_column :household_members, :steps_completed
  	remove_column :household_members, :earned_income_flag
  	remove_column :household_members, :unearned_income_flag
  	remove_column :household_members, :job_offer_flag

  	  # 2.referential integrity
  	execute <<-SQL
    	ALTER TABLE household_members
		ADD CONSTRAINT household_members_household_id_fkey
		    FOREIGN KEY (household_id)
		    REFERENCES households(id);
    SQL

      # 3. unique constraints - application_id & client_id combination is unique
    execute <<-SQL
  			ALTER TABLE household_members
			ADD CONSTRAINT hh_member_household_id_and_client_id_unique UNIQUE (household_id,client_id);
	SQL

  end
end
