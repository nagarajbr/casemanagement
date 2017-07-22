namespace :assessment_questions_mtdt_education_other_edu_certificate_task9 do
	desc "Assessment Education Lrng Difficlty Response"
	task :assessment_questions_mtdt_other_edu_cert => :environment do


    	AssessmentQuestionMetadatum.create(assessment_question_id:219,response_data_type:"LABEL",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:220,response_data_type:"RADIO",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:221,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1,response_max_lngth:250,response_max_val:250)
    	AssessmentQuestionMetadatum.create(assessment_question_id:222,response_data_type:"RADIO",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:223,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1,response_max_lngth:250,response_max_val:250)
        AssessmentQuestionMetadatum.create(assessment_question_id:224,response_data_type:"RADIO",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:225,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1,response_max_lngth:250,response_max_val:250)
        AssessmentQuestionMetadatum.create(assessment_question_id:226,response_data_type:"RADIO",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:227,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1,response_max_lngth:250,response_max_val:250)

        AssessmentQuestionMetadatum.create(assessment_question_id:228,response_data_type:"RADIO",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:229,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1,response_max_lngth:250,response_max_val:250)
        AssessmentQuestionMetadatum.create(assessment_question_id:230,response_data_type:"RADIO",created_by: 1,updated_by: 1)
        AssessmentQuestionMetadatum.create(assessment_question_id:471,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1,response_max_lngth:250,response_max_val:250)



    end
end