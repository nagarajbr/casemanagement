namespace :assessment_questions_multi_response_education_english_task5 do
	desc "Assessment Education English Response"
	task :assessment_education_english => :environment do
		 connection = ActiveRecord::Base.connection()
    	connection.execute("TRUNCATE TABLE public.assessment_question_multi_responses")
    	connection.execute("SELECT setval('public.assessment_question_multi_responses_id_seq', 1, true)")

		AssessmentQuestionMultiResponse.create(assessment_question_id:44,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:44,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:45,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:45,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:47,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:47,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:48,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:48,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)


    end
end