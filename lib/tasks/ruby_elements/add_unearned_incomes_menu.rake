namespace :add_unearned_income_menu do
	desc "This is a template to create menu items"
	task :add_unearned_income_menu => :environment do

			# level_2_menu - mental health
			level_2_menu = RubyElement.find(21)


			level_3_menu = RubyElement.create(element_name:"/CLIENT/unearned_incomes",element_title:"Unearned Income", element_type: 6350, element_microhelp:"unearned_incomes")
				RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: level_3_menu.id, child_order: 15)

			# Refer to access_rights folder within lib and verify that an entry is made for each access_right file

			# Do the following steps for all different roles available in the system, refer to roles table for more info

			user_role_id = 6 # Manager
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			user_role_id = 5 # Supervisor
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			user_role_id = 3 #  specialist
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		
		    # update incomes menu as earned income
		    RubyElement.where("id in(22)").update_all("element_name = '/CLIENT/earned_incomes',element_title = 'Earned Income', element_microhelp = 'CLIENT/earned_incomes' ")
		    RubyElement.where("id in(21)").update_all("element_name = '/CLIENT/earned_incomes',element_title = 'Income', element_microhelp = 'CLIENT/earned_incomes' ")

	end
end
