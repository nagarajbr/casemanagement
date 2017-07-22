namespace :add_menu_items_to_work_load_management1 do
	desc "This is a template to create menu items"
	task :create_menu_items => :environment do
		connection = ActiveRecord::Base.connection()
    	connection.execute("delete from access_rights where ruby_element_id in (select id from ruby_elements where element_name = '/my_program_units' and element_title = 'My Program Units')")
    	connection.execute("delete from ruby_element_reltns where child_element_id in (select id from ruby_elements where element_name = '/my_program_units' and element_title = 'My Program Units')")
    	connection.execute("delete from ruby_elements where element_name = '/my_program_units' and element_title = 'My Program Units'")

    	connection.execute("delete from access_rights where ruby_element_id in (select id from ruby_elements where element_name = '/my_applications' and element_title = 'My Applications')")
    	connection.execute("delete from ruby_element_reltns where child_element_id in (select id from ruby_elements where element_name = '/my_applications' and element_title = 'My Applications')")
    	connection.execute("delete from ruby_elements where element_name = '/my_applications' and element_title = 'My Applications'")

    	connection.execute("delete from access_rights where ruby_element_id in (select id from ruby_elements where element_name = '/search_work_tasks/search_criteria' and element_title = 'Search')")
    	connection.execute("delete from ruby_element_reltns where child_element_id in (select id from ruby_elements where element_name = '/search_work_tasks/search_criteria' and element_title = 'Search')")
    	connection.execute("delete from ruby_elements where element_name = '/search_work_tasks/search_criteria' and element_title = 'Search'")

    	connection.execute("SELECT setval('public.access_rights_id_seq', (select max(id) from public.access_rights), true)")
    	connection.execute("SELECT setval('public.ruby_element_reltns_id_seq', (select max(id) from public.ruby_element_reltns), true)")
    	connection.execute("SELECT setval('public.ruby_elements_id_seq', (select max(id) from public.ruby_elements), true)")
		# level_1_menu = RubyElement.create(element_name:"url",element_title:"Display Name", element_type: 6350, element_microhelp:"highlights_on", element_help_page:"session_var_dependency",parent_order: "valid_sequence")
		# 	RubyElementReltn.create(parent_element_id: level_1_menu.id,child_element_id: level_1_menu.id)

		level_1_menu = RubyElement.find(135) # Workload Management
		# Note: In case if we are adding menu items at level 2 and if its going to be the first menu item at level 2,
		# 	then we need to update element_name and element_microhelp of level_1_menu with that of level_2_menu
		# My Program Units menu item
		level_2_menu = RubyElement.create(element_name:"/my_program_units",element_title:"My Program Units", element_type: 6350, element_microhelp:"my_program_units")
			RubyElementReltn.create(parent_element_id: level_1_menu.id,child_element_id: level_2_menu.id, child_order: 50)

		level_3_menu = RubyElement.create(element_name:"/my_program_units",element_title:"My Program Units", element_type: 6350, element_microhelp:"my_program_units")
			RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: level_3_menu.id, child_order: 10)

		# Refer to access_rights folder within lib and verify that an entry is made for each access_right file

		# Do the following steps for all different roles available in the system, refer to roles table for more info

		user_role_id = 2 # System Support user
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 3 # Intake Worker
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 4 # Case Manager
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 5 # Supervisor
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 6 # Manager
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 7 # QA
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 8 # Workload Manager
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		# My Applications menu itemMy Applications

		level_2_menu = RubyElement.create(element_name:"/my_applications",element_title:"My Applications", element_type: 6350, element_microhelp:"my_applications")
			RubyElementReltn.create(parent_element_id: level_1_menu.id,child_element_id: level_2_menu.id, child_order: 60)

		level_3_menu = RubyElement.create(element_name:"/my_applications",element_title:"My Applications", element_type: 6350, element_microhelp:"my_applications")
			RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: level_3_menu.id, child_order: 10)

		# Refer to access_rights folder within lib and verify that an entry is made for each access_right file

		# Do the following steps for all different roles available in the system, refer to roles table for more info

		user_role_id = 2 # System Support user
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 3 # Intake Worker
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 4 # Case Manager
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 5 # Supervisor
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 6 # Manager
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 7 # QA
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 8 # Workload Manager
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		# Search menu item

		level_2_menu = RubyElement.create(element_name:"/search_work_tasks/search_criteria",element_title:"Search", element_type: 6350, element_microhelp:"search_work_tasks")
		level_1_menu.update(element_name:"/search_work_tasks/search_criteria",element_microhelp:"search_work_tasks")
			RubyElementReltn.create(parent_element_id: level_1_menu.id,child_element_id: level_2_menu.id, child_order: 2)

		level_3_menu = RubyElement.create(element_name:"/search_work_tasks/search_criteria",element_title:"Search", element_type: 6350, element_microhelp:"search_work_tasks")
			RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: level_3_menu.id, child_order: 10)

		# Refer to access_rights folder within lib and verify that an entry is made for each access_right file

		# Do the following steps for all different roles available in the system, refer to roles table for more info

		user_role_id = 2 # System Support user
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 3 # Intake Worker
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 4 # Case Manager
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 5 # Supervisor
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 6 # Manager
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 7 # QA
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 8 # Workload Manager
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
	end
end