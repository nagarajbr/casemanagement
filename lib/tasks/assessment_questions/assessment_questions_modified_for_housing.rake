namespace :assessment_questions_modified_for_housing do
	desc "Assessment questions modified for housing"
	task :assessment_questions_modified_for_housing => :environment do
           #Move questions from "Housing Situation" to "Current Housing" and Rename "Current Housing" to Housing Situation
         AssessmentQuestion.where("assessment_sub_section_id = 17 and id = 54").update_all(assessment_sub_section_id: 15,display_order: 3)
         AssessmentQuestion.where("assessment_sub_section_id = 15 and id = 803").update_all(display_order: 4  )
         AssessmentQuestion.where("assessment_sub_section_id = 15 and id = 50").update_all(display_order: 5)
         AssessmentQuestion.where("assessment_sub_section_id = 17 and id = 51").update_all(assessment_sub_section_id: 15,display_order: 6)
         AssessmentQuestion.where("assessment_sub_section_id = 17 and id = 804").update_all(assessment_sub_section_id: 15,display_order: 7)
		 AssessmentQuestion.where("assessment_sub_section_id = 17 and id = 231").update_all(assessment_sub_section_id: 15,display_order: 8)
		 AssessmentQuestion.where("assessment_sub_section_id = 17 and id = 52").update_all(assessment_sub_section_id: 15,display_order: 9)
		 AssessmentQuestion.where("assessment_sub_section_id = 17 and id = 53").destroy_all



	end
end