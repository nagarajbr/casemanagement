namespace :add_alerts_menu do
	desc "Add alerts menu under workload management"
	task :create_alert_menu_items => :environment do
		connection = ActiveRecord::Base.connection()
    	connection.execute("delete from access_rights where ruby_element_id in (select id from ruby_elements where element_name = '/alerts' and element_title = 'Alerts')")
    	connection.execute("delete from ruby_element_reltns where child_element_id in (select id from ruby_elements where element_name = '/alerts' and element_title = 'Alerts')")
    	connection.execute("delete from ruby_elements where element_name = '/alerts' and element_title = 'Alerts'")
    	connection.execute("SELECT setval('public.access_rights_id_seq', (select max(id) from public.access_rights), true)")
    	connection.execute("SELECT setval('public.ruby_element_reltns_id_seq', (select max(id) from public.ruby_element_reltns), true)")
    	connection.execute("SELECT setval('public.ruby_elements_id_seq', (select max(id) from public.ruby_elements), true)")

		# level_1_menu = RubyElement.create(element_name:"url",element_title:"Display Name", element_type: 6350, element_microhelp:"highlights_on", element_help_page:"session_var_dependency",parent_order: "valid_sequence")
		# 	RubyElementReltn.create(parent_element_id: level_1_menu.id,child_element_id: level_1_menu.id)

		level_1_menu = RubyElement.find(135) # Workload Management

		# Since this level_2_menu is gonna be the first secondary menu item update the level_1_menu element_name and element_microhelp to be in sync with level_2_menu
		level_2_menu = RubyElement.create(element_name:"/alerts",element_title:"Alerts", element_type: 6350, element_microhelp:"alerts")
			level_1_menu.update(element_name:"/alerts",element_microhelp:"alerts")
			RubyElementReltn.create(parent_element_id: level_1_menu.id,child_element_id: level_2_menu.id, child_order: 5)


		level_3_menu = RubyElement.create(element_name:"/alerts",element_title:"Alerts", element_type: 6350, element_microhelp:"alerts")
			RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: level_3_menu.id, child_order: 10)

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