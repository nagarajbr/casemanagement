namespace :assessment_questions_modified_for_childcare_and_parenting do
	desc "Assessment questions modified for childcare and parenting"
	task :assessment_questions_modified_for_childcare_and_parenting => :environment do


		connection = ActiveRecord::Base.connection()
		connection.execute("DELETE from assessment_question_metadata where assessment_question_id in (select id from assessment_questions where assessment_sub_section_id = 22 and id = 79)")
		connection.execute("DELETE from assessment_questions where assessment_sub_section_id = 22 and id = 79")



         AssessmentQuestion.where("assessment_sub_section_id = 21 and id = 723").update_all(assessment_sub_section_id: 22, title: "1. Are you currently providing caregiving services to any elderly or disabled members of your family?",question_text: "1. Are you currently providing caregiving services to any elderly or disabled members of your family?", display_order: 1  )
         AssessmentQuestion.where("assessment_sub_section_id = 21 and id = 724").update_all(title: " 2. Do you have children that are of the age to require child care?",question_text: "2. Do you have children that are of the age to require child care?")
         AssessmentQuestion.where("assessment_sub_section_id = 21 and id = 725").update_all(title: " 2a. If so, do you have child care?",question_text:" 2a. If so, do you have child care?")
         AssessmentQuestion.where("assessment_sub_section_id = 21 and id = 726").update_all(title: " 2b. Do your child care arrangements provide you the ability to work effectively?",question_text: "2b. Do your child care arrangements provide you the ability to work effectively?")
		 AssessmentQuestion.where("assessment_sub_section_id = 22 and id = 80").update_all( display_order: 2)


	end
end