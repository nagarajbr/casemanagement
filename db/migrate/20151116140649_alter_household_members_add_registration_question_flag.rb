class AlterHouseholdMembersAddRegistrationQuestionFlag < ActiveRecord::Migration
  def change
  		add_column :household_members, :registration_questions_add_flag, "char(1)"
  end
end
