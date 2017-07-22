namespace :assessment_questions_mtdt_education_lrng_difficlty_task8 do
	desc "Assessment Education Lrng Difficlty Response"
	task :assessment_questions_mtdt_lrng_difficlty => :environment do


    	AssessmentQuestionMetadatum.create(assessment_question_id:158,response_data_type:"LABEL",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:159,response_data_type:"RADIO",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:160,response_data_type:"RADIO",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:161,response_data_type:"RADIO",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:162,response_data_type:"RADIO",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:163,response_data_type:"RADIO",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:164,response_data_type:"RADIO",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:165,response_data_type:"RADIO",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:166,response_data_type:"RADIO",created_by: 1,updated_by: 1)

        AssessmentQuestionMetadatum.create(assessment_question_id:167,response_data_type:"RADIO",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:168,response_data_type:"RADIO",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:169,response_data_type:"RADIO",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:170,response_data_type:"RADIO",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:171,response_data_type:"RADIO",created_by: 1,updated_by: 1)


    end
end