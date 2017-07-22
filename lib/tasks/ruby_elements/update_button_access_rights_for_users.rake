namespace :update_and_create_button_access_rights_for_provider_agreements do
	desc "update button access rights for provider agreements"
	task :update_and_create_button_access_rights_for_provider_agreements => :environment do



		# user_role_id = 5 # Supervisor
				AccessRight.where("role_id = 5 and ruby_element_id = 687").update_all(access:'Y')#update
		user_role_id = 6 # Manager
		        AccessRight.create(role_id: user_role_id, ruby_element_id: 687,access:'Y', created_at: Time.now, updated_at: Time.now)#create
		user_role_id = 7 # QA
	            AccessRight.create(role_id: user_role_id, ruby_element_id: 687,access:'N', created_at: Time.now, updated_at: Time.now)#create
    	user_role_id = 8 # Workload Manager
				AccessRight.create(role_id: user_role_id, ruby_element_id: 687,access:'N', created_at: Time.now, updated_at: Time.now)#create
		# user_role_id = 12# compliance officer
				AccessRight.where("role_id = 12 and ruby_element_id = 687").update_all(access:'N')#update




	end
end
