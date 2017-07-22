namespace :assessment_questions_mtdt_employment_work_interest_task14 do
	desc "Assessment Employment Work Interests"
	task :assessment_questions_mtdt_employment_wrk_interests => :environment do
    	AssessmentQuestionMetadatum.create(assessment_question_id:41,response_data_type:"CHECKBOXGROUP",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:42,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)
	end
end