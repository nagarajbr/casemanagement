class AlterHouseholdMembersDrugScreeningAnswerFields < ActiveRecord::Migration
  def change
  	add_column :household_members, :drug_screening_question1_answer_flag, "char(1)"
  	add_column :household_members, :drug_screening_question2_answer_flag, "char(1)"
  	add_column :household_members, :drug_screening_question3_answer_flag, "char(1)"
  	add_column :household_members, :drug_screening_do_not_want_to_answer_question_flag, "char(1)"
  end
end
