namespace :assessment_questions_mtdt_gen_health_current_health_task38 do
        desc "Assessment General Health Current Health"
        task :assessment_questions_mtdt_gen_health_current_health => :environment do

    		AssessmentQuestionMetadatum.create(assessment_question_id:702,response_data_type:"LABEL",created_by: 1,updated_by: 1)
            AssessmentQuestionMetadatum.create(assessment_question_id:66,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
            AssessmentQuestionMetadatum.create(assessment_question_id:67,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
            AssessmentQuestionMetadatum.create(assessment_question_id:68,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
            AssessmentQuestionMetadatum.create(assessment_question_id:64,response_data_type:"RADIOGROUP",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
            AssessmentQuestionMetadatum.create(assessment_question_id:516,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
            AssessmentQuestionMetadatum.create(assessment_question_id:65,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
            AssessmentQuestionMetadatum.create(assessment_question_id:69,response_data_type:"DATE",created_by: 1,updated_by: 1)

        end
end