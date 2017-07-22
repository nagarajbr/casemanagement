namespace :assessment_questions_multi_response_education_other_edu_certificate_task10 do

	desc "Assessment Education Learning Difficulties Response"
	task :assessment_education_multi_rspnse_other_edu_certificate => :environment do

		AssessmentQuestionMultiResponse.create(assessment_question_id:220,txt:"Yes",val:"Y",created_by: 1,updated_by: 1,display_order: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:220,txt:"No",val:"N",created_by: 1,updated_by: 1,display_order: 2)

		AssessmentQuestionMultiResponse.create(assessment_question_id:222,txt:"Yes",val:"Y",created_by: 1,updated_by: 1,display_order: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:222,txt:"No",val:"N",created_by: 1,updated_by: 1,display_order: 2)

		AssessmentQuestionMultiResponse.create(assessment_question_id:224,txt:"Yes",val:"Y",created_by: 1,updated_by: 1,display_order: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:224,txt:"No",val:"N",created_by: 1,updated_by: 1,display_order: 2)

		AssessmentQuestionMultiResponse.create(assessment_question_id:226,txt:"Yes",val:"Y",created_by: 1,updated_by: 1,display_order: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:226,txt:"No",val:"N",created_by: 1,updated_by: 1,display_order: 2)

		AssessmentQuestionMultiResponse.create(assessment_question_id:228,txt:"Yes",val:"Y",created_by: 1,updated_by: 1,display_order: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:228,txt:"No",val:"N",created_by: 1,updated_by: 1,display_order: 2)

		AssessmentQuestionMultiResponse.create(assessment_question_id:230,txt:"Yes",val:"Y",created_by: 1,updated_by: 1,display_order: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:230,txt:"No",val:"N",created_by: 1,updated_by: 1,display_order: 2)



    end
end