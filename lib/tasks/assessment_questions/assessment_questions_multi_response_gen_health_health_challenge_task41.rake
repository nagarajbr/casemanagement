namespace :assessment_questions_multi_response_gen_health_health_challenge_task41 do

	desc "Assessment General Health Health Challenge"
	task :assessment_questions_multi_response_gen_health_health_challenge => :environment do

		AssessmentQuestionMultiResponse.create(assessment_question_id:70,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:70,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)


    end
end