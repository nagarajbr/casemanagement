namespace :assessment_questions_multi_response_relationship_relationship_task66 do

	desc "Assessment relationship Relationship"
	task :assessment_questions_multi_response_relationship_relationship => :environment do

		AssessmentQuestionMultiResponse.create(assessment_question_id:876,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:876,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:732,txt:"Single",val:"Single",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:732,txt:"Dating/In a Relationship",val:"Dating/In a Relationship",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:732,txt:"Married",val:"Married",display_order: 3,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:732,txt:"Separated",val:"Separated",display_order: 4,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:732,txt:"Divorced",val:"Divorced",display_order: 5,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:733,txt:"Strong and Happy",val:"Strong and Happy",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:733,txt:"Having issues/working on them",val:"Having issues/working on them",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:733,txt:"Not Good/On the Rocks",val:"Not Good/On the Rocks",display_order: 3,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:734,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:734,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)
    end
end