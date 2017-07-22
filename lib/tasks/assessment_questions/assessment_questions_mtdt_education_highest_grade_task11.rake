namespace :assessment_questions_mtdt_education_highest_grade_task11 do
	desc "Assessment Education Lrng Difficlty Response"
	task :assessment_questions_mtdt_highest_grade => :environment do


    	AssessmentQuestionMetadatum.create(assessment_question_id:232,response_data_type:"LABEL",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:141,response_data_type:"RADIO",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:142,response_data_type:"RADIO",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:629,response_data_type:"TEXT",created_by: 1,updated_by: 1,response_max_lngth:10,response_max_val:10)
    	AssessmentQuestionMetadatum.create(assessment_question_id:143,response_data_type:"RADIO",created_by: 1,updated_by: 1)

        AssessmentQuestionMetadatum.create(assessment_question_id:642,response_data_type:"TEXT",created_by: 1,updated_by: 1,response_max_lngth:10,response_max_val:10)

        AssessmentQuestionMetadatum.create(assessment_question_id:144,response_data_type:"RADIO",created_by: 1,updated_by: 1)

        AssessmentQuestionMetadatum.create(assessment_question_id:643,response_data_type:"TEXT",created_by: 1,updated_by: 1,response_max_lngth:10,response_max_val:10)

        AssessmentQuestionMetadatum.create(assessment_question_id:145,response_data_type:"RADIO",created_by: 1,updated_by: 1)


        AssessmentQuestionMetadatum.create(assessment_question_id:644,response_data_type:"TEXT",created_by: 1,updated_by: 1,response_max_lngth:10,response_max_val:10)

        AssessmentQuestionMetadatum.create(assessment_question_id:500,response_data_type:"RADIO",created_by: 1,updated_by: 1,response_max_lngth:250,response_max_val:250)
        AssessmentQuestionMetadatum.create(assessment_question_id:501,response_data_type:"TEXT",created_by: 1,updated_by: 1,response_max_lngth:2,response_max_val:2)
        AssessmentQuestionMetadatum.create(assessment_question_id:557,response_data_type:"TEXT",created_by: 1,updated_by: 1,response_max_lngth:250,response_max_val:250)



    end
end