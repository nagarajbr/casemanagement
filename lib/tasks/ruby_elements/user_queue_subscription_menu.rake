namespace :add_user_subscription_menu_to_work_load_management do
	desc "This is a template to create menu items"
	task :add_user_subscription_menu_to_work_load_management => :environment do

		RubyElement.where("id = 811").update_all(element_title: 'Local Office Queue Subscription')
		# delete user subscription menu from queue subscription.
		RubyElementReltn.where("parent_element_id = 811 and child_element_id = 813").destroy_all
		# level_1_menu = RubyElement.create(element_name:"url",element_title:"Display Name", element_type: 6350, element_microhelp:"highlights_on", element_help_page:"session_var_dependency",parent_order: "valid_sequence")
		# 	RubyElementReltn.create(parent_element_id: level_1_menu.id,child_element_id: level_1_menu.id)

		level_1_menu = RubyElement.find(135) # Workload Management
		# Note: In case if we are adding menu items at level 2 and if its going to be the first menu item at level 2,
		# 	then we need to update element_name and element_microhelp of level_1_menu with that of level_2_menu
		# My Program Units menu item
		level_2_menu =  RubyElement.find(813)
			RubyElementReltn.create(parent_element_id: level_1_menu.id,child_element_id: level_2_menu.id, child_order: 100)

		level_3_menu = RubyElement.create(element_name:"/work_queue_user_subscriptions/index",element_title:"User Queue Subscription", element_type: 6350, element_microhelp:"work_queue_user_subscriptions")
			RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: level_3_menu.id, child_order: 10)



		# Refer to access_rights folder within lib and verify that an entry is made for each access_right file

		# Do the following steps for all different roles available in the system, refer to roles table for more info

		user_role_id = 6 # Manager
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)


		user_role_id = 5 # Supervisor
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 3 # Intake worker - in future - specialist
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'N', created_at: Time.now, updated_at: Time.now)

		user_role_id = 2 # System Support
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)




	end
end