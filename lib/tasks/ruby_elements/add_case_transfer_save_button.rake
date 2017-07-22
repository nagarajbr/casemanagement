namespace :create_buttons_for_case_transfer do
	desc "create buttons for program unit transfer"
	task :create_buttons_for_case_transfer => :environment do

		type = 6351

		save_button = RubyElement.create(element_name:"ProgramUnitTransfersController",element_title:"Save", element_type: type, description: "Case transfer")

		user_role_id = 3 # specialist

				AccessRight.create(role_id: user_role_id, ruby_element_id: save_button.id,  access:'Y', created_at: Time.now, updated_at: Time.now)


		user_role_id = 5 # Supervisor

				AccessRight.create(role_id: user_role_id, ruby_element_id: save_button.id,  access:'Y', created_at: Time.now, updated_at: Time.now)


		user_role_id = 6 # Manager

				AccessRight.create(role_id: user_role_id, ruby_element_id: save_button.id,  access:'Y', created_at: Time.now, updated_at: Time.now)


	end
end
