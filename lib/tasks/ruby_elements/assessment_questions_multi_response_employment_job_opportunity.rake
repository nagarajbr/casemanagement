namespace :assessment_questions_multi_response_employment_job_opportunity do
	desc "Assessment Employment Job Opportunity"
	task :assessment_questions_multi_response_employment_job_opportunity => :environment do
		AssessmentQuestionMultiResponse.where("assessment_question_id =7 and txt = 'Quit'").update_all(txt:'Jobs were outsourced', val:'Jobs were outsourced',display_order: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:7,txt:"Company closure",val:"Company closure",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.where("assessment_question_id =7 and txt = 'No jobs available'").update_all(display_order: 3)
	end
end
