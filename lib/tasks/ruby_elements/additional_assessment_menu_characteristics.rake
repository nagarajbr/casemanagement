namespace :additional_assessment_menu_characteristics do
	desc "This is a template to create menu items"
	task :additional_assessment_menu_characteristics => :environment do

		# Add Immunization into  characteristics menu


		level_2_menu = RubyElement.find(107)
		level_3_menu = RubyElement.create(element_name:"/ASSESSMENT/client_immunization/show",element_title:"Immunization", element_type: 6350, element_microhelp:"ASSESSMENT/client_immunization")
			RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: level_3_menu.id, child_order: 20)
			# Refer to access_rights folder within lib and verify that an entry is made for each access_right file
			# Do the following steps for all different roles available in the system, refer to roles table for more info
			user_role_id = 6 # Manager
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			user_role_id = 5 # Supervisor
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			user_role_id = 3 #  specialist
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		# Add pregnancy to characteristics menu.
		# level_2_menu = RubyElement.find(107)
		# level_3_menu = RubyElement.create(element_name:"ASSESSMENT/clients/medical_pregnancy/show",element_title:"Pregnancy", element_type: 6350, element_microhelp:"ASSESSMENT/clients/medical_pregnancy")
		# 	RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: level_3_menu.id, child_order: 39)
		# 	# Refer to access_rights folder within lib and verify that an entry is made for each access_right file
		# 	# Do the following steps for all different roles available in the system, refer to roles table for more info
		# 	user_role_id = 6 # Manager
		# 			AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
		# 	user_role_id = 5 # Supervisor
		# 			AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
		# 	user_role_id = 3 #  specialist
		# 			AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

	    # DISABILITY
	    # Add pregnancy to characteristics menu.
		level_2_menu = RubyElement.find(107)
		level_3_menu = RubyElement.create(element_name:"/ASSESSMENT/disability/characteristics/index",element_title:"Disability Details", element_type: 6350, element_microhelp:"ASSESSMENT/disability")
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