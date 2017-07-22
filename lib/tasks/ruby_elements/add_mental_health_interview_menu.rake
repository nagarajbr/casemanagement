namespace :add_mental_health_interview_menu do
	desc "This is a template to create menu items"
	task :add_mental_health_interview_menu => :environment do

			# level_2_menu - mental health
			level_2_menu = RubyElement.find(110)

			level_3_menu = RubyElement.create(element_name:"/35/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment",element_title:"Mental Health-Interview", element_type: 6350, element_microhelp:"35/assessment_")
				RubyElementReltn.create(parent_element_id: level_2_menu.id,child_element_id: level_3_menu.id, child_order: 15)

			# Refer to access_rights folder within lib and verify that an entry is made for each access_right file

			# Do the following steps for all different roles available in the system, refer to roles table for more info

			user_role_id = 6 # Manager
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			user_role_id = 5 # Supervisor
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			user_role_id = 3 #  specialist
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_3_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		#  update element title of Mental health doagnosis to 'Diagnosis-Interview'
			# level_3_menu = RubyElement.find(112)
			# level_3_menu.element_title = "Diagnosis-Interview"
			# level_3_menu.save
		#  update the access rights so that menu will be visible.
		   # AccessRight.where("role_id in (3,5,6) and ruby_element_id = 112").update_all("access = 'Y'")


	end
end