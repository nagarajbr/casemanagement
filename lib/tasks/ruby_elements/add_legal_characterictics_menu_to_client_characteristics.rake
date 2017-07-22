namespace :add_legal_characteristics_menu do
	desc "Add legal characteristics menu under Charactertistics"
	task :create_legal_characteristics_menu_items => :environment do
		connection = ActiveRecord::Base.connection()
    	connection.execute("delete from access_rights where ruby_element_id in (select id from ruby_elements where element_name = '/clients/legal/characteristics/index' and element_title = 'Legal')")
    	connection.execute("delete from ruby_element_reltns where child_element_id in (select id from ruby_elements where element_name = '/clients/legal/characteristics/index' and element_title = 'Legal')")
    	connection.execute("delete from ruby_elements where element_name = '/clients/legal/characteristics/index' and element_title = 'Legal'")
    	connection.execute("SELECT setval('public.access_rights_id_seq', (select max(id) from public.access_rights), true)")
    	connection.execute("SELECT setval('public.ruby_element_reltns_id_seq', (select max(id) from public.ruby_element_reltns), true)")
    	connection.execute("SELECT setval('public.ruby_elements_id_seq', (select max(id) from public.ruby_elements), true)")

		level_1_menu_id = 4 # "Master Client Data Management"

		# Since this level_2_menu is gonna be the first secondary menu item update the level_1_menu element_name and element_microhelp to be in sync with level_2_menu
		level_2_menu_id = 12 #"Characteristics"


		level_3_menu = RubyElement.create(element_name:"/clients/legal/characteristics/index",element_title:"Legal", element_type: 6350, element_microhelp:"legal")
		RubyElementReltn.create(parent_element_id: level_2_menu_id,child_element_id: level_3_menu.id, child_order: 35)

		# Do the following steps for all different roles available in the system, refer to roles table for more info
		user_role_id = 2 # System Support user
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			# AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 3 # Intake Worker
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			# AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 4 # Case Manager
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			# AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 5 # Supervisor
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			# AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 6 # Manager
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			# AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 7 # QA
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			# AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 8 # Workload Manager
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			# AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

	end
end