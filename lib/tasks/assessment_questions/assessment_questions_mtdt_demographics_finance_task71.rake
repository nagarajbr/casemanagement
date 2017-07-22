namespace :assessment_questions_mtdt_demographics_finance_task71 do
        desc "Assessment Finance"
        task :assessment_questions_mtdt_demographics_finance => :environment do
        AssessmentQuestionMetadatum.create(assessment_question_id:877,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:878,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:879,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:880,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
         AssessmentQuestionMetadatum.create(assessment_question_id:881,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
        end
end