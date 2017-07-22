namespace :assessment_questions_mtdt_transportation_transportation_challenge_task36 do
        desc "Assessment Transportation Transportation Challenge"
        task :assessment_questions_mtdt_transportation_transportation_challenge => :environment do

                AssessmentQuestionMetadatum.create(assessment_question_id:62,response_data_type:"RADIO",created_by: 1,updated_by: 1)
                AssessmentQuestionMetadatum.create(assessment_question_id:63,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)

        end
end