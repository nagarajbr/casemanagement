namespace :assessment_questions_employment_job_opportunity4 do
	desc "Assessment Employment Job Opportunity"
	task :assessment_questions_employment_job_opportunity4 => :environment do


		AssessmentQuestion.where("id = 495").update_all(title:'Unemployed for over a year',question_text:'Unemployed for over a year',display_order:19)
		AssessmentQuestion.where("id = 89").update_all(display_order:20)


	end
end


