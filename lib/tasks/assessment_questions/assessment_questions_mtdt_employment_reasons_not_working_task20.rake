namespace :assessment_questions_mtdt_employment_reasons_not_working_task20 do
	desc "Assessment Employment reasons not Working"
	task :assessment_questions_mtdt_employment_reasons_not_working => :environment do
    	AssessmentQuestionMetadatum.create(assessment_question_id:88,response_data_type:"LABEL",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:6,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:7,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:8,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:9,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:10,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:11,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:12,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:13,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:14,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:15,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:16,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:89,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:495,response_data_type:"CHECKBOX",created_by: 1,updated_by: 1)
	end
end