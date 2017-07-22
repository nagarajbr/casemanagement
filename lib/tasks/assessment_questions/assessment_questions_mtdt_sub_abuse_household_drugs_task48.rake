namespace :assessment_questions_mtdt_sub_abuse_household_drugs_task48 do
        desc "Assessment Substance Abuse Household Drugs"
        task :assessment_questions_mtdt_sub_abuse_household_drugs => :environment do
        AssessmentQuestionMetadatum.create(assessment_question_id:75,response_data_type:"RADIO",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:76,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)
        end
end