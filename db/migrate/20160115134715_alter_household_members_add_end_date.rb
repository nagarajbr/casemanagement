class AlterHouseholdMembersAddEndDate < ActiveRecord::Migration
  def change
  		remove_column :household_members, :household_member_role
  		remove_column :household_members, :household_participation_status

  		rename_column :household_members, :household_participation_date, :start_date
  		add_column :household_members, :end_date, :date

  		remove_column :household_members, :registration_status

  		remove_column :household_members, :ethnicity_add_flag
  		remove_column :household_members, :citizenship_add_flag
  		remove_column :household_members, :contacts_add_flag
  		remove_column :household_members, :income_add_flag
  		remove_column :household_members, :registration_questions_add_flag
  		remove_column :household_members, :general_health_chalng_to_work_charcteristics_found_add_flag
  		remove_column :household_members, :disability_charcteristics_found_add_flag
  		remove_column :household_members, :mental_health_issues_charcteristics_found_add_flag
  		remove_column :household_members, :substnce_abuse_issues_charcteristics_found_add_flag
  		remove_column :household_members, :domestic_violence_issues_charcteristics_found_add_flag
  		remove_column :household_members, :legal_issues_charcteristics_found_add_flag
  		remove_column :household_members, :pregnancy_charcteristics_found_add_flag
  		remove_column :household_members, :immunization_charcteristics_found_add_flag
  		remove_column :household_members, :drug_screening_question1_answer_flag
  		remove_column :household_members, :drug_screening_question2_answer_flag
  		remove_column :household_members, :drug_screening_question3_answer_flag
  		remove_column :household_members, :drug_screening_do_not_want_to_answer_question_flag

  		remove_column :households, :household_status
  		remove_column :households, :registration_status


  end
end
