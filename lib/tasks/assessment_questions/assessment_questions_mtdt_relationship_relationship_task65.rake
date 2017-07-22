namespace :assessment_questions_mtdt_relationship_relationship_task65 do
        desc "Assessment Relationship Relationship"
        task :assessment_questions_mtdt_relationship_relationship => :environment do

        AssessmentQuestionMetadatum.create(assessment_question_id:731,response_data_type:"LABEL",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:876,response_data_type:"RADIO",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:732,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:733,response_data_type:"RADIOGROUP",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:734,response_data_type:"RADIO",created_by: 1,updated_by: 1)

        end
end