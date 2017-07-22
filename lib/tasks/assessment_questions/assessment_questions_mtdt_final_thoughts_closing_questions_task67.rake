namespace :assessment_questions_mtdt_final_thoughts_closing_questions_task67 do
        desc "Assessment Final Thoughts and Closing Questions"
        task :assessment_questions_mtdt_final_thoughts_closing_questions => :environment do

        AssessmentQuestionMetadatum.create(assessment_question_id:86,response_data_type:"RADIO",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:87,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)


        end
end