namespace :create_buttons_for_program_wizard do
	desc "create buttons for program wizard"
	task :create_buttons_for_program_wizard => :environment do

		type = 6351

		approve_button_object = RubyElement.create(element_name:"ProgramWizardsController",element_title:"Approve Benefit Amount", element_type: type)
		reject_button_object =RubyElement.create(element_name:"ProgramWizardsController",element_title:"Reject Benefit Amount", element_type: type)


		user_role_id = 2 # System Support user

				AccessRight.create(role_id: user_role_id, ruby_element_id: approve_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: reject_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)


		user_role_id = 3 # Intake Worker

				AccessRight.create(role_id: user_role_id, ruby_element_id: approve_button_object.id,  access:'N', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: reject_button_object.id,  access:'N', created_at: Time.now, updated_at: Time.now)


		user_role_id = 4 # Case Manager

				AccessRight.create(role_id: user_role_id, ruby_element_id: approve_button_object.id,  access:'N', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: reject_button_object.id,  access:'N', created_at: Time.now, updated_at: Time.now)


		user_role_id = 5 # Supervisor

				AccessRight.create(role_id: user_role_id, ruby_element_id: approve_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: reject_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)



		user_role_id = 6 # Manager

				AccessRight.create(role_id: user_role_id, ruby_element_id: approve_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: reject_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)


		user_role_id = 7 # QA

				AccessRight.create(role_id: user_role_id, ruby_element_id: approve_button_object.id,  access:'N', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: reject_button_object.id,  access:'N', created_at: Time.now, updated_at: Time.now)


		user_role_id = 8 # Workload Manager

				AccessRight.create(role_id: user_role_id, ruby_element_id: approve_button_object.id,  access:'N', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: reject_button_object.id,  access:'N', created_at: Time.now, updated_at: Time.now)


		user_role_id = 12 # Compliance officer

				AccessRight.create(role_id: user_role_id, ruby_element_id: approve_button_object.id,  access:'N', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: reject_button_object.id,  access:'N', created_at: Time.now, updated_at: Time.now)






	end
end
