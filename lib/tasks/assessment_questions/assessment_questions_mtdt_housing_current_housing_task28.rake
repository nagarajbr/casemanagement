namespace :assessment_questions_mtdt_housing_current_housing_task28 do
        desc "Assessment Employment Spoken Language"
        task :assessment_questions_mtdt_housing_current_housing => :environment do

                AssessmentQuestionMetadatum.create(assessment_question_id:699,response_data_type:"LABEL",created_by: 1,updated_by: 1)

                AssessmentQuestionMetadatum.create(assessment_question_id:49,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)

                AssessmentQuestionMetadatum.create(assessment_question_id:803,response_data_type:"RADIOGROUP",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)

                AssessmentQuestionMetadatum.create(assessment_question_id:50,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)

        end
end