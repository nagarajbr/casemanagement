namespace :update_assessment_questions_for_drivers_license do
	desc "updating Assessment Questions and sub section for drivers license "
	task :update_assessment_questions_for_drivers_license => :environment do
		AssessmentQuestion.find(57).update(title: "Do you have a valid driver's license?")

	end
end
