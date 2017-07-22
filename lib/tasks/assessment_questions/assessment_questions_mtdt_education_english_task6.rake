namespace :assessment_questions_mtdt_education_english_task6 do
	desc "Assessment Education English Response"
	task :assessment_questions_mtdt_english => :environment do
		 connection = ActiveRecord::Base.connection()
    	connection.execute("TRUNCATE TABLE public.assessment_question_metadata")
    	connection.execute("SELECT setval('public.assessment_question_metadata_id_seq', 1, true)")

    	AssessmentQuestionMetadatum.create(assessment_question_id:43,response_data_type:"LABEL",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:44,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:45,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:46,response_data_type:"LABEL",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:47,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:48,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)

    end
end