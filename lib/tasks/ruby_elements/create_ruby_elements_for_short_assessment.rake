namespace :add_new_menu_for_short_assessment do
	desc "Adding a new menu item for short assessment"
	task :short_assessment_menu => :environment do

		level_2_menu = RubyElement.create(element_name:"/client_assessments/session[:CLIENT_ID]/selected_sections_for_short_assessment",element_title:"Assessment Categories", element_type: 6350, element_microhelp:"selected_sections_for_short_assessment")
		level_3_menu = RubyElement.create(element_name:"/client_assessments/session[:CLIENT_ID]/selected_sections_for_short_assessment",element_title:"Assessment Categories", element_type: 6350, element_microhelp:"selected_sections_for_short_assessment")

		RubyElementReltn.create(parent_element_id: 82,child_element_id: level_2_menu.id, child_order: 5)
		RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: level_3_menu.id, child_order: 10)

		RubyElement.where("id = 82").update_all(element_name:"/client_assessments/session[:CLIENT_ID]/selected_sections_for_short_assessment", element_microhelp:"selected_sections_for_short_assessment")

	end
end

