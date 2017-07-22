namespace :assessment_questions_mtdt_employment_currently_working_task18 do
	desc "Assessment Employment Currently Working"
	task :assessment_questions_mtdt_employment_currently_working => :environment do
    	AssessmentQuestionMetadatum.create(assessment_question_id:2,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:3,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:4,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:5,response_data_type:"RADIOGROUP",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:592,response_data_type:"RADIO",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:593,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)



	end
end