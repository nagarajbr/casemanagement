namespace :assessment_questions_multi_response_gen_health_current_health_task39 do

	desc "Assessment General Health Current Health"
	task :assessment_questions_multi_response_gen_health_current_health => :environment do

		AssessmentQuestionMultiResponse.create(assessment_question_id:66,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:66,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:67,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:67,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:68,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:68,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:64,txt:"Excellent",val:"Excellent",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:64,txt:"Very Good",val:"Very Good",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:64,txt:"Good",val:"Good",display_order: 3,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:64,txt:"Fair",val:"Fair",display_order: 4,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:64,txt:"Poor",val:"Poor",display_order: 5,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:516,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:516,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:65,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:65,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

    end
end