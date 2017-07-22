namespace :assessment_questions_multi_response_men_health_diagnosis_task45 do

	desc "Assessment Mental Health Diagnosis"
	task :assessment_questions_multi_response_men_health_diagnosis => :environment do

		AssessmentQuestionMultiResponse.create(assessment_question_id:72,txt:"Mental health condition",val:"Mental health condition",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:72,txt:"Attention deficit disorder",val:"Attention deficit disorder",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:72,txt:"Other",val:"Other",display_order: 3,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:72,txt:"None",val:"None",display_order: 4,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:74,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:74,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

    end
end