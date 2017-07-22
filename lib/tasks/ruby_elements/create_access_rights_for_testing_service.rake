namespace :access_rights_for_testing_service do
	desc "access rights for testing service"
	task :access_rights_for_testing_service => :environment do

		user_role_id = 3 # specialist
			AccessRight.create(role_id: user_role_id, ruby_element_id: 914,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 5 # Supervisor
			AccessRight.create(role_id: user_role_id, ruby_element_id: 914,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 6 # Manager
			AccessRight.create(role_id: user_role_id, ruby_element_id: 914,  access:'Y', created_at: Time.now, updated_at: Time.now)

	end
end
