namespace :assessment_questions_multi_response_employment_legal_barriers_task23 do

	desc "Assessment Employment Legal Barriers"
	task :assessment_questions_multi_response_employment_legal_barriers => :environment do

		AssessmentQuestionMultiResponse.create(assessment_question_id:33,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:33,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:34,txt:"Felony",val:"Felony",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:34,txt:"Misdemeanor",val:"Misdemeanor",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:36,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:36,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:37,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:37,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

    end
end