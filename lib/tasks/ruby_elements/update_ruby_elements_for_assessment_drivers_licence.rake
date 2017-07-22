namespace :update_ruby_elements_for_assessment_drivers_licence do
	desc "update ruby elements for assessment drivers licence"
	task :update_ruby_elements_for_assessment_drivers_licence => :environment do
	  RubyElement.find(105).update(element_title: "Driver's License")
	 end
end