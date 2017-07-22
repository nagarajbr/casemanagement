namespace :adding_access_rights_for_short_assessment do
	desc "This is for access rights for short assessment"
	task :adding_access_rights_for_short_assessment => :environment do

			user_role_id = 6 # Manager
					AccessRight.create(role_id: user_role_id, ruby_element_id: 867,  access:'Y', created_at: Time.now, updated_at: Time.now)
			user_role_id = 5 # Supervisor
					AccessRight.create(role_id: user_role_id, ruby_element_id: 867,  access:'Y', created_at: Time.now, updated_at: Time.now)
			user_role_id = 3 #  specialist
					AccessRight.create(role_id: user_role_id, ruby_element_id: 867,  access:'Y', created_at: Time.now, updated_at: Time.now)

			user_role_id = 6 # Manager
					AccessRight.create(role_id: user_role_id, ruby_element_id: 868,  access:'Y', created_at: Time.now, updated_at: Time.now)
			user_role_id = 5 # Supervisor
					AccessRight.create(role_id: user_role_id, ruby_element_id: 868,  access:'Y', created_at: Time.now, updated_at: Time.now)
			user_role_id = 3 #  specialist
					AccessRight.create(role_id: user_role_id, ruby_element_id: 868,  access:'Y', created_at: Time.now, updated_at: Time.now)

	end
end