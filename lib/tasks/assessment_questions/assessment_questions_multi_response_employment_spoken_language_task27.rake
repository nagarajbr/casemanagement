namespace :assessment_questions_multi_response_employment_spoken_language_task27 do

	desc "Assessment Employment Spoken Language"
	task :assessment_questions_multi_response_employment_spoken_language => :environment do

		AssessmentQuestionMultiResponse.create(assessment_question_id:39,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:39,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:40,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:40,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:646,txt:"Limited",val:"Limited",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:646,txt:"Average",val:"Average",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:646,txt:"Fluent",val:"Fluent",display_order: 3,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:648,txt:"Limited",val:"Limited",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:648,txt:"Average",val:"Average",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:648,txt:"Fluent",val:"Fluent",display_order: 3,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:650,txt:"Limited",val:"Limited",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:650,txt:"Average",val:"Average",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:650,txt:"Fluent",val:"Fluent",display_order: 3,created_by: 1,updated_by: 1)



    end
end