namespace :assessment_questions_multi_response_housing_current_housing_task29 do

	desc "Assessment Employment Spoken Language"
	task :assessment_questions_multi_response_housing_current_housing => :environment do

		AssessmentQuestionMultiResponse.create(assessment_question_id:49,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:49,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:803,txt:"Rent/own house/apartment",val:"Rent/own house/apartment",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:803,txt:"Staying in a shelter",val:"Staying in a shelter",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:803,txt:"Transitional housing",val:"Transitional housing",display_order: 3,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:803,txt:"Homeless",val:"Homeless",display_order: 4,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:803,txt:"Sharing house/apartment with family/friends",val:"Sharing house/apartment with family/friends",display_order: 5,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:803,txt:"Other",val:"Other",display_order: 6,created_by: 1,updated_by: 1)

    end
end