namespace :service_authorization_line_items_submit_button do
	desc "service authorization line items submit button access rights"
	task :service_authorization_line_items_submit_button_access_rights => :environment do



		button_object = RubyElement.create(element_name:"ServiceAuthorizationLineItemsController",element_title:"Submit", element_type: 6351)



		user_role_id = 2 # System Support user

				AccessRight.create(role_id: user_role_id, ruby_element_id: button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 3 # Intake Worker

				AccessRight.create(role_id: user_role_id, ruby_element_id: button_object.id,  access:'N', created_at: Time.now, updated_at: Time.now)

		user_role_id = 4 # Case Manager

				AccessRight.create(role_id: user_role_id, ruby_element_id: button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 5 # Supervisor

				AccessRight.create(role_id: user_role_id, ruby_element_id: button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 6 # Manager

				AccessRight.create(role_id: user_role_id, ruby_element_id: button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 7 # QA

				AccessRight.create(role_id: user_role_id, ruby_element_id: button_object.id,  access:'N', created_at: Time.now, updated_at: Time.now)

		user_role_id = 8 # Workload Manager

				AccessRight.create(role_id: user_role_id, ruby_element_id: button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)


	end
end