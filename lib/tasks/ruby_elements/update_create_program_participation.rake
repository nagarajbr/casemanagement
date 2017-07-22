namespace :update_create_program_participation do
	desc "update create program participation"
	task :update_create_program_participation => :environment do
          # ruby element id = 40 --"Program Participation"
          # ruby element id = 41-- "Program Participation" to "Time Limits"
          RubyElement.find(41).update(element_title: "Time Limits")


		level_3_menu = RubyElement.create(element_name:"/payment_line_items",element_title:"Service Payments", element_type: 6350, element_microhelp:"payment_line_items",element_help_page: "CL")
		level_3_menu.destroy
			RubyElementReltn.create(parent_element_id: 40 ,child_element_id: level_3_menu.id, child_order: 40).destroy
		level_3_menu = RubyElement.create(element_name:"/payment_line_items",element_title:"Service Payments", element_type: 6350, element_microhelp:"payment_line_items",element_help_page: "CL")
			RubyElementReltn.create(parent_element_id: 40 ,child_element_id: level_3_menu.id, child_order: 40)

			user_role_id = 2 # System Support user
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 3 # Intake Worker
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 4 # Case Manager
	     		AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 5 # Supervisor
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		# user_role_id = 6 # Manager
	 #        	AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 7 # QA
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 8 # Workload Manager
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
		user_role_id = 12 # compliance officer
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

			end
		end

