namespace :assessment_questions_multi_response_transportation_transportation_method_task33 do

	desc "Assessment Transportation Transportation Method"
	task :assessment_questions_multi_response_transportation_transportation_method => :environment do

		AssessmentQuestionMultiResponse.create(assessment_question_id:805,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:805,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:55,txt:"Drive my own vehicle",val:"Drive my own vehicle",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:55,txt:"Ride with someone",val:"Ride with someone",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:55,txt:"Borrow a vehicle",val:"Borrow a vehicle",display_order: 3,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:55,txt:"Use public transportation (bus, train, subway, etc)",val:"Use public transportation (bus, train, subway, etc)",display_order: 4,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:55,txt:"Bicycle",val:"Bicycle",display_order: 5,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:55,txt:"Walk",val:"Walk",display_order: 6,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:55,txt:"I do not go to job and/or work activity now and I do not know how I would get to job and/or work activity",val:"I do not go to job and/or work activity now and I do not know how I would get to job and/or work activity",display_order: 7,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:55,txt:"Other",val:"Other",display_order: 8,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:61,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:61,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:508,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:508,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:701,txt:"15 minutes",val:"15 minutes",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:701,txt:"30 minutes",val:"30 minutes",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:701,txt:"45 minutes",val:"45 minutes",display_order: 3,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:701,txt:"1 hour",val:"1 hour",display_order: 4,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:701,txt:"Other",val:"Other",display_order: 5,created_by: 1,updated_by: 1)

    end
end