namespace :assessment_questions_mtdt_child_care_primary_caregiver_task58 do
        desc "Assessment Child Care Primary Caregiver"
        task :assessment_questions_mtdt_child_care_primary_caregiver => :environment do

        AssessmentQuestionMetadatum.create(assessment_question_id:80,response_data_type:"TEXTAREA",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:79,response_data_type:"CHECKBOX",created_by: 1,updated_by: 1)

        end
end