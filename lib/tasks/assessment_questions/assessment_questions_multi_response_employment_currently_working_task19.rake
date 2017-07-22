namespace :assessment_questions_multi_response_employment_currently_working_task19 do

	desc "Assessment Employment Career Interests Response"
	task :assessment_education_multi_rspnse_employment_currently_working => :environment do

		AssessmentQuestionMultiResponse.create(assessment_question_id:2,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:2,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:3,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:3,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)


		AssessmentQuestionMultiResponse.create(assessment_question_id:5,txt:"Agriculture, Food, and Natural Resources",val:"Agriculture, Food, and Natural Resources",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:5,txt:"Architecture and Construction",val:"Architecture and Construction",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:5,txt:"Arts, Audio/Video Technology and Communications",val:"Arts, Audio/Video Technology and Communications",display_order: 3,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:5,txt:"Education and Training",val:"Education and Training",display_order: 4,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:5,txt:"Finance",val:"Finance",display_order: 5,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:5,txt:"Government and Public Administration",val:"Government and Public Administration",display_order: 6,created_by: 1,updated_by: 1)


		AssessmentQuestionMultiResponse.create(assessment_question_id:5,txt:"Health Science",val:"Health Science",display_order: 7,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:5,txt:"Hospitality and Tourism",val:"Hospitality and Tourism",display_order: 8,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:5,txt:"Human Services",val:"Human Services",display_order: 9,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:5,txt:"Information Technology",val:"Information Technology",display_order:10,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:5,txt:"Law, Public Safety, Corrections, and Security",val:"Law, Public Safety, Corrections, and Security",display_order:11,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:5,txt:"Manufacturing",val:"Manufacturing",display_order:12,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:5,txt:"Marketing",val:"Marketing",display_order:13,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:5,txt:"Science, Technology, Engineering, and Mathematics",val:"Science, Technology, Engineering, and Mathematics",display_order:14,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:5,txt:"Transportation, Distribution, and Logistics",val:"Transportation, Distribution, and Logistics",display_order:15,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:592,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:592,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:593,txt:"Computer / Internet Access",val:"Computer / Internet Access",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:593,txt:"Email Address",val:"Email Address",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:593,txt:"Current Resume",val:"Current Resume",display_order: 3,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:593,txt:"Valid ID",val:"Valid ID",display_order: 4,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:593,txt:"Social Security Card",val:"Social Security Card",display_order: 5,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:593,txt:"Birth Certificate",val:"Birth Certificate",display_order: 6,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:593,txt:"Bank Account",val:"Bank Account",display_order: 7,created_by: 1,updated_by: 1)

    end
end