namespace :add_intake_management_menu do
	desc "This is a template to create menu items"
	task :add_intake_management_hh_finance_top_menu => :environment do
		level_2_menu = RubyElement.find(841)
		level_3_menu = RubyElement.create(element_name:"/household_finance/navigate_to_household_finance_index",element_title:"Household Finance", element_type: 6350, element_microhelp:"household_finance")
			RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: level_3_menu.id, child_order: 30)
			# Refer to access_rights folder within lib and verify that an entry is made for each access_right file
			# Do the following steps for all different roles available in the system, refer to roles table for more info
			user_role_id = 6 # Manager
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			user_role_id = 5 # Supervisor
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			user_role_id = 3 #  specialist
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

	end
end