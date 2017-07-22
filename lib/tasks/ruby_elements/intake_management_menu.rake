namespace :add_intake_management_menu do
	desc "This is a template to create menu items"
	task :add_intake_management_menu => :environment do


		# delete if they are present
		ruby_element_collection = RubyElement.where("element_type = 6350
									              and element_name = '/household_registration/index'
									              and element_title in ('Intake Management',
									              	                     'Household Registration',
									              	                     'Household Composition'
									              	                     )
									              ")
		if ruby_element_collection.present?
			ruby_element_collection.each do |each_menu_element|
				AccessRight.where("ruby_element_id = ?",each_menu_element.id).destroy_all
			end
			ruby_element_collection.destroy_all
		else
			# create

			# RubyElement.where("id = 811").update_all(element_title: 'Local Office Queue Subscription')
			# delete user subscription menu from queue subscription.
			# RubyElementReltn.where("parent_element_id = 811 and child_element_id = 813").destroy_all
			level_1_menu = RubyElement.create(element_name:"/household_registration/index",element_title:"Intake Management", element_type: 6350, parent_order: 15)
			RubyElementReltn.create(parent_element_id: level_1_menu.id,child_element_id: level_1_menu.id)


			# Note: In case if we are adding menu items at level 2 and if its going to be the first menu item at level 2,
			# 	then we need to update element_name and element_microhelp of level_1_menu with that of level_2_menu
			# My Program Units menu item
			level_2_menu = RubyElement.create(element_name:"/household_registration/index",element_title:"Household Registration", element_type: 6350)
				RubyElementReltn.create(parent_element_id: level_1_menu.id,child_element_id: level_2_menu.id, child_order: 10)

			level_3_menu = RubyElement.create(element_name:"/household_registration/index",element_title:"Household Composition", element_type: 6350, element_microhelp:"household_registration")
				RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: level_3_menu.id, child_order: 10)

			# Refer to access_rights folder within lib and verify that an entry is made for each access_right file

			# Do the following steps for all different roles available in the system, refer to roles table for more info

			user_role_id = 6 # Manager
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)



			user_role_id = 5 # Supervisor
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)


			user_role_id = 3 #  specialist
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)


		end








	end
end