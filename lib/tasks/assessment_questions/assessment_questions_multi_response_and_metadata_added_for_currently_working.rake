namespace :assessment_questions_multi_response_and_metadata_added_for_currently_working do
	desc "Assessment question, multi response and metadata added for currently working "
	task :assessment_questions_multi_response_and_metadata_added_for_currently_working  => :environment do
        user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)
		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:2,title:"Have you ever held a paying job?",question_text:"Have you ever held a paying job?",display_order:35,enabled:1,required:1,created_by: 1,updated_by: 1)
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

	end
end