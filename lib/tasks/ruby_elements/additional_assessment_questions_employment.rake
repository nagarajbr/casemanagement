namespace :assessment_questions_employment_job_opportunity do
	desc "Assessment Employment Job Opportunity"
	task :assessment_questions_employment_job_opportunity => :environment do
		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:2,title:"Is it a full time job? Is it a Part time job?",question_text:"Is it a full time job? Is it a Part time job?",display_order:21,enabled:1,required:1,created_by: 1,updated_by: 1)
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"RADIO",created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:2,title:"Does the job offer Health Insurance benefits to cover you and your immediate family?",question_text:"Does the job offer Health Insurance benefits to cover you and your immediate family?",display_order:22,enabled:1,required:1,created_by: 1,updated_by: 1)
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"RADIO",created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)


		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:2,title:"Does the job help you become self-sufficient?",question_text:"Does the job help you become self-sufficient?",display_order:21,enabled:1,required:1,created_by: 1,updated_by: 1)
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"RADIO",created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)




	end
end