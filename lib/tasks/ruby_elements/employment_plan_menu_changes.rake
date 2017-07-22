namespace :employment_plan_menu_changes do
	desc "Updating access rights"
	task :apply_menu_changes => :environment do
		AccessRight.where("ruby_element_id in (150,151)").update_all("access = 'N'")

		level_1_menu = RubyElement.find(145)

		level_2_menu =  RubyElement.create(element_name:"/supportive_service/service_authorizations/session[:PROGRAM_UNIT_ID]/index",element_title:"Supportive Service", element_type: 6350, element_microhelp:"supportive_service",element_help_page: "PU")
			RubyElementReltn.create(parent_element_id: level_1_menu.id,child_element_id: level_2_menu.id, child_order: 25)

			user_role_id = 6 # Manager
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

			user_role_id = 5 # Supervisor
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

			user_role_id = 3 # Intake worker - in future - specialist
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

			user_role_id = 2 # System Support
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		level_3_menu = RubyElement.create(element_name:"/supportive_service/service_authorizations/session[:PROGRAM_UNIT_ID]/index",element_title:"Supportive Service", element_type: 6350, element_microhelp:"supportive_service",element_help_page: "PU")
			RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: level_3_menu.id, child_order: 10)

			user_role_id = 6 # Manager
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

			user_role_id = 5 # Supervisor
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

			user_role_id = 3 # Intake worker - in future - specialist
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

			user_role_id = 2 # System Support
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
   	end
end