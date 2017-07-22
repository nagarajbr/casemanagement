namespace :add_additional_household_menus_for_household do
	desc "This is a template to create menu items"
	task :add_additional_household_menus_for_household => :environment do

			# level 1 - Intake management
			level_1_menu = RubyElement.find(840)
			# level_2_menu - absent parent

			level_2_menu = RubyElement.create(element_name:"/household_absent_parent/index",element_title:"Absent Parent", element_type: 6350)
				RubyElementReltn.create(parent_element_id: level_1_menu.id,child_element_id: level_2_menu.id, child_order: 20)

			level_3_menu = RubyElement.create(element_name:"/household_absent_parent/index",element_title:"Absent Parent Registration", element_type: 6350, element_microhelp:"household_absent_parent")
				RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: level_3_menu.id, child_order: 10)

			# Refer to access_rights folder within lib and verify that an entry is made for each access_right file

			# Do the following steps for all different roles available in the system, refer to roles table for more info

			user_role_id = 6 # Manager
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)



			user_role_id = 5 # Supervisor
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)


			user_role_id = 3 #  specialist
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)


	#  HOUSEHOLD ADDRESS CHANGE START
			# level 1 - Intake management
			level_1_menu = RubyElement.find(840)
			# level_2_menu - household address change

			level_2_menu = RubyElement.create(element_name:"/household_address_change/index",element_title:"Household Address", element_type: 6350)
				RubyElementReltn.create(parent_element_id: level_1_menu.id,child_element_id: level_2_menu.id, child_order: 30)

			level_3_menu = RubyElement.create(element_name:"/household_address_change/index",element_title:"Household Address Change", element_type: 6350, element_microhelp:"household_address_change")
				RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: level_3_menu.id, child_order: 10)

			# Refer to access_rights folder within lib and verify that an entry is made for each access_right file

			# Do the following steps for all different roles available in the system, refer to roles table for more info

			user_role_id = 6 # Manager
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)



			user_role_id = 5 # Supervisor
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)


			user_role_id = 3 #  specialist
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

	# HOUSEHOLD ADDRESS CHANGE END


	#  HOUSEHOLD PROGRAM UNIT TRANSFER START

		# level 1 - Intake management
			level_1_menu = RubyElement.find(840)
			# level_2_menu - household address change

			level_2_menu = RubyElement.create(element_name:"/program_unit_transfers/index",element_title:"Household Program Units", element_type: 6350)
				RubyElementReltn.create(parent_element_id: level_1_menu.id,child_element_id: level_2_menu.id, child_order: 40)

			level_3_menu = RubyElement.create(element_name:"/program_unit_transfers/index",element_title:"Program Unit Transfer", element_type: 6350, element_microhelp:"program_unit_transfers")
				RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: level_3_menu.id, child_order: 10)

			# Refer to access_rights folder within lib and verify that an entry is made for each access_right file

			# Do the following steps for all different roles available in the system, refer to roles table for more info

			user_role_id = 6 # Manager
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)



			user_role_id = 5 # Supervisor
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)


			user_role_id = 3 #  specialist
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)


	#  HOUSEHOLD PROGRAM UNIT TRANSFER END



	end
end