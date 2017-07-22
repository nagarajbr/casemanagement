namespace :update_career_interests_in_work_readiness_assessments_menu do
	desc "update career interests in work readiness assessments menu"
	task :update_career_interests_in_work_readiness_assessments_menu => :environment do
		RubyElement.where("element_name = '/9/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment'").update_all(element_name: "/assessment_careers/interest_profiler_questions/interest_profiler_question_wizard_initialize", element_microhelp: "assessment_careers")
	end
end