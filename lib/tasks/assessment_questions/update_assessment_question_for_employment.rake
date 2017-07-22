namespace :update_assessment_question_for_employment do
	desc "update_assessment_employment_tea_diversion "
	task :update_assessment_question_for_employment => :environment do
		AssessmentQuestion.find(88).update(title: "Do you have challenges in retaining current employment or why do you think you are not currently working?")

	end
end
