namespace :update_assessment_questions_for_child_care_parenting do
	desc "updating Assessment Questions title for child care and parenting -backup child plan "
	task :update_assessment_questions_for_child_care_parenting => :environment do


		AssessmentQuestion.find(85).update(title: "What is your plan for your children when the primary provider is not available or your children are sick and cannot go to childcare?"	)

	end
end