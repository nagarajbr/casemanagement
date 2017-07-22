namespace :assessment_questions_multi_response_transportation_transportation_challenge_task37 do

	desc "Assessment Transportation Transportation Challenge"
	task :assessment_questions_multi_response_transportation_transportation_challenge => :environment do

		AssessmentQuestionMultiResponse.create(assessment_question_id:62,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:62,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

    end
end