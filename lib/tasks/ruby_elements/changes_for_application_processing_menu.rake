namespace :adding_application_procesing_menu do
	desc "This task is used to disable the existing menu for application processing and add a new one instead"
	task :adding_application_procesing_menu => :environment do

		AccessRight.where("ruby_element_id between 55 and 60").update_all(access:'N')
		level_2_menu = RubyElement.create(element_name:"/application/application_processing/application_processing_wizard",element_title:"Application Processing", element_type: 6350, element_microhelp:"application_processing", element_help_page: "AP")
		RubyElementReltn.create(parent_element_id: 52,child_element_id: level_2_menu.id, child_order: 40)
			user_role_id = 6 # Manager
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			user_role_id = 5 # Supervisor
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			user_role_id = 3 #  specialist
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

			level_3_menu = RubyElement.create(element_name:"/application/application_processing/application_processing_wizard",element_title:"Application Processing", element_type: 6350, element_microhelp:"application_processing", element_help_page: "AP")
			RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: level_3_menu.id, child_order: 10)
			user_role_id = 6 # Manager
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			user_role_id = 5 # Supervisor
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			user_role_id = 3 #  specialist
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

	end
end