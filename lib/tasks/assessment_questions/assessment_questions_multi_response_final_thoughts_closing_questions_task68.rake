namespace :assessment_questions_multi_response_final_thoughts_closing_questions_task68 do

	desc "Assessment Final Thoughts and Closing Questions"
	task :assessment_questions_multi_response_final_thoughts_closing_questions => :environment do

		AssessmentQuestionMultiResponse.create(assessment_question_id:86,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:86,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

    end
end