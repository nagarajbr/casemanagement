namespace :menu_for_assessment_plan do
	desc "Adding a new menu item for short assessment"
	task :add_menu => :environment do
		level_2_menu = RubyElement.create(element_name:"/clients/assessment/activity",element_title:"Assessment Plan", element_type: 6350, element_microhelp:"clients/assessment")
		level_3_menu = RubyElement.create(element_name:"/clients/assessment/activity",element_title:"Assessment Plan", element_type: 6350, element_microhelp:"clients/assessment")

		user_role_id = 6 # Manager
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
		user_role_id = 5 # Supervisor
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
		user_role_id = 3 #  specialist
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 6 # Manager
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
		user_role_id = 5 # Supervisor
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
		user_role_id = 3 #  specialist
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		RubyElementReltn.create(parent_element_id: 82,child_element_id: level_2_menu.id, child_order: 3)
		RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: level_3_menu.id, child_order: 10)
		RubyElement.where("id = 82").update_all(element_name:"/clients/assessment/activity", element_microhelp:"clients/assessment")
	end
end