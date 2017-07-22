namespace :add_testing_service_factor  do
	desc "adding a factor testing service and moving scores from education to testing service"
	task :add_testing_service_factor  => :environment do

		level_2_menu = RubyElement.create(element_name:"/ASSESSMENT/client_scores",element_title:"Testing Service", element_type: 6350, element_microhelp:"ASSESSMENT/client_scores")

		RubyElementReltn.where(parent_element_id: 83, child_element_id: 728).destroy_all

		RubyElementReltn.create(parent_element_id: 82,child_element_id: level_2_menu.id ,child_order:20)
		RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: 728 ,child_order:10)
   end
end