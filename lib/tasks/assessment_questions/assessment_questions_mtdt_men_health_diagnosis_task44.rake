namespace :assessment_questions_mtdt_men_health_diagnosis_task44 do
        desc "Assessment Mental Health Diagnosis"
        task :assessment_questions_mtdt_men_health_diagnosis => :environment do
                AssessmentQuestionMetadatum.create(assessment_question_id:72,response_data_type:"CHECKBOXGROUP",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
                AssessmentQuestionMetadatum.create(assessment_question_id:73,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)
                AssessmentQuestionMetadatum.create(assessment_question_id:74,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
                AssessmentQuestionMetadatum.create(assessment_question_id:558,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)
        end
end