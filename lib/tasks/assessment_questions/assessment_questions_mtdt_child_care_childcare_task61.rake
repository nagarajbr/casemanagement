namespace :assessment_questions_mtdt_child_care_childcare_task61 do
        desc "Assessment Child Care Childcare"
        task :assessment_questions_mtdt_child_care_childcare => :environment do

        AssessmentQuestionMetadatum.create(assessment_question_id:81,response_data_type:"LABEL",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:82,response_data_type:"RADIO",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:83,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:84,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)

        end
end