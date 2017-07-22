namespace :assessment_questions_mtdt_employment_career_interest_task16 do
	desc "Assessment Employment Career Interests"
	task :assessment_questions_mtdt_employment_career_interests => :environment do
    	AssessmentQuestionMetadatum.create(assessment_question_id:559,response_data_type:"CHECKBOXGROUP",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
    	AssessmentQuestionMetadatum.create(assessment_question_id:560,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)
	end
end