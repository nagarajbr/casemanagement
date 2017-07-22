namespace :assessment_questions_employment_job_opportunity3 do
	desc "Assessment Employment Job Opportunity"
	task :assessment_questions_employment_job_opportunity3 => :environment do


		AssessmentQuestion.where("id = 887").update_all(display_order:23)
		AssessmentQuestion.where("id = 886").update_all(display_order:24)


	end
end