namespace :assessment_questions_mtdt_child_care_parenting_and_child_support_task59 do
        desc "Assessment Child Care parenting and child support"
        task :assessment_questions_mtdt_child_care_parenting_and_child_support => :environment do

        	AssessmentQuestionMetadatum.create(assessment_question_id:563,response_data_type:"RADIOGROUP",created_by: 1,updated_by: 1)

			AssessmentQuestionMetadatum.create(assessment_question_id:564,response_data_type:"TEXT",created_by: 1,updated_by: 1)

			AssessmentQuestionMetadatum.create(assessment_question_id:565,response_data_type:"RADIO",created_by: 1,updated_by: 1)

			AssessmentQuestionMetadatum.create(assessment_question_id:727,response_data_type:"TEXT",created_by: 1,updated_by: 1)

			AssessmentQuestionMetadatum.create(assessment_question_id:728,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:729,response_data_type:"RADIO",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:730,response_data_type:"RADIO",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:566,response_data_type:"RADIO",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:567,response_data_type:"TEXT",created_by: 1,updated_by: 1)


			AssessmentQuestionMetadatum.create(assessment_question_id:765,response_data_type:"RADIO",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:766,response_data_type:"RADIO",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:767,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:568,response_data_type:"RADIO",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:570,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)

			AssessmentQuestionMetadatum.create(assessment_question_id:569,response_data_type:"RADIO",created_by: 1,updated_by: 1)
			AssessmentQuestionMetadatum.create(assessment_question_id:571,response_data_type:"RADIO",created_by: 1,updated_by: 1)

        end
end