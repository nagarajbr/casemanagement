namespace :assessment_questions_mtdt_transportation_transportation_method_task32 do
        desc "Assessment Transportation Transportation Method"
        task :assessment_questions_mtdt_transportation_transportation_method => :environment do

        	AssessmentQuestionMetadatum.create(assessment_question_id:700,response_data_type:"LABEL",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:805,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:55,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:56,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:61,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:508,response_data_type:"RADIO",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:509,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:510,response_data_type:"TEXT",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:511,response_data_type:"TEXT",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:701,response_data_type:"RADIOGROUP",created_by: 1,updated_by: 1)

        end
end