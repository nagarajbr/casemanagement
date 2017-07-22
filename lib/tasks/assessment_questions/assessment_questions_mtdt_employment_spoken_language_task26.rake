namespace :assessment_questions_mtdt_employment_spoken_language_task26 do
	desc "Assessment Employment Spoken Language"
	task :assessment_questions_mtdt_employment_spoken_language => :environment do

                AssessmentQuestionMetadatum.create(assessment_question_id:39,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)

                AssessmentQuestionMetadatum.create(assessment_question_id:40,response_data_type:"RADIO",created_by: 1,updated_by: 1)

                AssessmentQuestionMetadatum.create(assessment_question_id:498,response_data_type:"LABEL",created_by: 1,updated_by: 1)

                AssessmentQuestionMetadatum.create(assessment_question_id:645,response_data_type:"TEXT",created_by: 1,updated_by: 1)
                AssessmentQuestionMetadatum.create(assessment_question_id:646,response_data_type:"RADIOGROUP",created_by: 1,updated_by: 1)

                AssessmentQuestionMetadatum.create(assessment_question_id:647,response_data_type:"TEXT",created_by: 1,updated_by: 1)
                AssessmentQuestionMetadatum.create(assessment_question_id:648,response_data_type:"RADIOGROUP",created_by: 1,updated_by: 1)

                AssessmentQuestionMetadatum.create(assessment_question_id:649,response_data_type:"TEXT",created_by: 1,updated_by: 1)
                AssessmentQuestionMetadatum.create(assessment_question_id:650,response_data_type:"RADIOGROUP",created_by: 1,updated_by: 1)
	end
end