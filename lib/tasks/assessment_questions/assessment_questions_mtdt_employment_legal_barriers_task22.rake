namespace :assessment_questions_mtdt_employment_legal_barriers_task22 do
	desc "Assessment Employment Legal Barriers"
	task :assessment_questions_mtdt_employment_legal_barriers => :environment do
        AssessmentQuestionMetadatum.create(assessment_question_id:33,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:34,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:35,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:36,response_data_type:"RADIO",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:37,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:38,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)
        # AssessmentQuestionMetadatum.create(assessment_question_id:601,response_data_type:"TEXT",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:600,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:601,response_data_type:"DATE",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:599,response_data_type:"DATE",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:602,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:595,response_data_type:"DATE",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:596,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:597,response_data_type:"DATE",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:598,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)
	end
end