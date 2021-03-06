namespace :add_queue_subscription_menu_to_work_load_management do
	desc "This is a template to create menu items"
	task :add_queue_subscription_menu_to_work_load_management => :environment do

		# level_1_menu = RubyElement.create(element_name:"url",element_title:"Display Name", element_type: 6350, element_microhelp:"highlights_on", element_help_page:"session_var_dependency",parent_order: "valid_sequence")
		# 	RubyElementReltn.create(parent_element_id: level_1_menu.id,child_element_id: level_1_menu.id)

		level_1_menu = RubyElement.find(135) # Workload Management
		# Note: In case if we are adding menu items at level 2 and if its going to be the first menu item at level 2,
		# 	then we need to update element_name and element_microhelp of level_1_menu with that of level_2_menu
		# My Program Units menu item
		level_2_menu = RubyElement.create(element_name:"/work_queue_local_office_subscriptions/index",element_title:"Queue Subscription", element_type: 6350, element_microhelp:"work_queue_local_office_subscriptions")
			RubyElementReltn.create(parent_element_id: level_1_menu.id,child_element_id: level_2_menu.id, child_order: 80)

		level_3_menu = RubyElement.create(element_name:"/work_queue_local_office_subscriptions/index",element_title:"Local Office Queue Subscription", element_type: 6350, element_microhelp:"work_queue_local_office_subscriptions")
			RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: level_3_menu.id, child_order: 10)

		level_3_menu2 = RubyElement.create(element_name:"/work_queue_user_subscriptions/index",element_title:"User Queue Subscription", element_type: 6350, element_microhelp:"work_queue_user_subscriptions")
			RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: level_3_menu2.id, child_order: 20)

		# Refer to access_rights folder within lib and verify that an entry is made for each access_right file

		# Do the following steps for all different roles available in the system, refer to roles table for more info

		user_role_id = 2 # System Support user
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu2.id,  access:'Y', created_at: Time.now, updated_at: Time.now)


		user_role_id = 5 # Supervisor
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu2.id,  access:'Y', created_at: Time.now, updated_at: Time.now)



	end
end