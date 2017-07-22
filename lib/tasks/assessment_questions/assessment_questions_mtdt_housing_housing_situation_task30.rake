namespace :assessment_questions_mtdt_housing_housing_situation_task30 do
        desc "Assessment Housing Housing Situation"
        task :assessment_questions_mtdt_housing_housing_situation => :environment do

			AssessmentQuestionMetadatum.create(assessment_question_id:51,response_data_type:"LABEL",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:804,response_data_type:"CHECKBOX",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:231,response_data_type:"TEXT",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:52,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:53,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:54,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)

        end
end