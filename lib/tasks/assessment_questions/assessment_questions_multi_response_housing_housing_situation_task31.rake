namespace :assessment_questions_multi_response_housing_housing_situation_task31 do

	desc "Assessment Housing Housing Situation"
	task :assessment_questions_multi_response_housing_housing_situation => :environment do

		# AssessmentQuestionMultiResponse.create(assessment_question_id:51,txt:"Has not moved",val:"Has not moved",display_order: 1,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:53,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:53,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

    end
end