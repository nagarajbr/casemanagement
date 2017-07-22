namespace :update_assessment_questions_for_substance_abuse do
	desc "updating Assessment Questions for substance abuse"
	task :update_assessment_questions_for_substance_abuse => :environment do
		AssessmentQuestion.find(541).update(display_order:5	)
		AssessmentQuestion.find(810).update(title: "2.Have you ever used marijuana or used other drugs including prescription drugs?")
  end
end
