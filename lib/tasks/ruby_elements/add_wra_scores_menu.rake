namespace :wra_scores_menu do
	desc "This is a template to create wra scores menu"
	task :wra_scores_menu => :environment do
		connection = ActiveRecord::Base.connection()
    	connection.execute("delete from access_rights where ruby_element_id in (select id from ruby_elements where element_name = '/ASSESSMENT/client_scores' and element_title = 'Scores')")
    	connection.execute("delete from ruby_element_reltns where child_element_id in (select id from ruby_elements where element_name = '/ASSESSMENT/client_scores' and element_title = 'Scores')")
    	connection.execute("delete from ruby_elements where element_name = '/ASSESSMENT/client_scores' and element_title = 'Scores'")

		# level_1_menu = RubyElement.create(element_name:"url",element_title:"Display Name", element_type: 6350, element_microhelp:"highlights_on", element_help_page:"session_var_dependency",parent_order: "valid_sequence")
		# 	RubyElementReltn.create(parent_element_id: level_1_menu.id,child_element_id: level_1_menu.id)

		# level_1_menu = RubyElement.find(135) # Workload Management
		# Note: In case if we are adding menu items at level 2 and if its going to be the first menu item at level 2,
		# 	then we need to update element_name and element_microhelp of level_1_menu with that of level_2_menu
		# My Program Units menu item


		level_3_menu = RubyElement.create(element_name:"/ASSESSMENT/client_scores",element_title:"Scores", element_type: 6350, element_microhelp:"ASSESSMENT/client_scores")
			RubyElementReltn.create(parent_element_id: 83 ,child_element_id: level_3_menu.id, child_order: 50)

		# Refer to access_rights folder within lib and verify that an entry is made for each access_right file

		# Do the following steps for all different roles available in the system, refer to roles table for more info

		user_role_id = 2 # System Support user
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			# AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 3 # Intake Worker
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			# AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'N', created_at: Time.now, updated_at: Time.now)

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