namespace :assessment_questions_multi_response_sub_abuse_household_drugs_task49 do

	desc "Assessment Substance Abuse Household Drugs"
	task :assessment_questions_multi_response_sub_abuse_household_drugs => :environment do

		AssessmentQuestionMultiResponse.create(assessment_question_id:75,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:75,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

    end
end