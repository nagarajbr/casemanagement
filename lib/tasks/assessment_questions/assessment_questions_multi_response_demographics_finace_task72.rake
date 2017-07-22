namespace :assessment_questions_multi_response_demographics_finace_task72 do
	desc "Assessment Demographics Finance question Response"
	task :assessment_demographics_finance => :environment do

		AssessmentQuestionMultiResponse.create(assessment_question_id:877,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:877,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:878,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:878,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:879,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:879,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:880,txt:"Good",val:"Good",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:880,txt:"Fair",val:"Fair",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:880,txt:"Bad",val:"Bad",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:881,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:881,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)



    end
end