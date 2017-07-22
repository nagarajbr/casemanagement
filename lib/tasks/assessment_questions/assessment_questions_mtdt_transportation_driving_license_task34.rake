namespace :assessment_questions_mtdt_transportation_driving_license_task34 do
        desc "Assessment Transportation Driver Licence"
        task :assessment_questions_mtdt_transportation_driving_license => :environment do

        	AssessmentQuestionMetadatum.create(assessment_question_id:57,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
        	AssessmentQuestionMetadatum.create(assessment_question_id:58,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
        	AssessmentQuestionMetadatum.create(assessment_question_id:59,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)
        	AssessmentQuestionMetadatum.create(assessment_question_id:60,response_data_type:"DROPDOWN",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
        	AssessmentQuestionMetadatum.create(assessment_question_id:512,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
        	AssessmentQuestionMetadatum.create(assessment_question_id:594,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)
        	AssessmentQuestionMetadatum.create(assessment_question_id:513,response_data_type:"DATE",created_by: 1,updated_by: 1)
        	AssessmentQuestionMetadatum.create(assessment_question_id:514,response_data_type:"DATE",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
        	AssessmentQuestionMetadatum.create(assessment_question_id:515,response_data_type:"TEXT",created_by: 1,updated_by: 1)

        end
end