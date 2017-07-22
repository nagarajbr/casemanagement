namespace :update_legal_characteristics_menu_for_assessments do
	desc "assessment characteristics"
	task :update_legal_characteristics_menu_for_assessments => :environment do
		# old values element_name: "/5/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment", element_microhelp: "3/assessment_"
		RubyElement.find(92).update(element_name: "/ASSESSMENT/legal/characteristics/index", element_microhelp: "ASSESSMENT/legal")
		# old values element_microhelp: "legal"
		RubyElement.find(727).update(element_microhelp: "clients/legal")
    end
end