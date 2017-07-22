namespace :assessment_employment_tea_diversion_update_questions do
	desc "assessment_employment_tea_diversion_additional_questions "
	task :assessment_employment_tea_diversion_update_questions => :environment do
		AssessmentQuestion.find(4).update(title: "Other reasons, please explain",display_order: 82)
		AssessmentQuestion.find(903).update(display_order: 84)

	end
end

