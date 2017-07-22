namespace :add_domestic_violence_interview_menu do
	desc "This is a template to create menu items"
	task :add_domestic_violence_interview_menu => :environment do

			# level_2_menu - "Domestic Violence - Safety"
			level_2_menu = RubyElement.find(116)

			level_3_menu = RubyElement.create(element_name:"/38/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment",element_title:"Victim-Interview", element_type: 6350, element_microhelp:"38/assessment_")
				RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: level_3_menu.id, child_order: 15)

			# Refer to access_rights folder within lib and verify that an entry is made for each access_right file

			# Do the following steps for all different roles available in the system, refer to roles table for more info

			user_role_id = 6 # Manager
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			user_role_id = 5 # Supervisor
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			user_role_id = 3 #  specialist
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		#  update element title of Mental health doagnosis to 'Perpetrator-Interview'
			level_3_menu = RubyElement.find(118)
			level_3_menu.element_title = "Perpetrator-Interview"
			level_3_menu.save
		#  update the access rights so that menu will be visible.
		   AccessRight.where("role_id in (3,5,6) and ruby_element_id = 118").update_all("access = 'Y'")


	end
end