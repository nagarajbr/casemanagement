namespace :assessment_questions_mtdt_child_care_backup_childcare_task63 do
        desc "Assessment Child Care Backup Childcare"
        task :assessment_questions_mtdt_child_care_backup_childcare => :environment do

        AssessmentQuestionMetadatum.create(assessment_question_id:85,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:526,response_data_type:"RADIO",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:527,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)

        end
end