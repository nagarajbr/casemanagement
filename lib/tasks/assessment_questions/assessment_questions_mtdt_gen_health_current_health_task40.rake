namespace :assessment_questions_mtdt_gen_health_health_challenge_task40 do
        desc "Assessment General Health Health Challenge"
        task :assessment_questions_mtdt_gen_health_health_challenge => :environment do

                AssessmentQuestionMetadatum.create(assessment_question_id:70,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
                AssessmentQuestionMetadatum.create(assessment_question_id:71,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)

        end
end