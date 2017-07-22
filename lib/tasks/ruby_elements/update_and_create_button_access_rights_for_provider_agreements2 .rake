namespace :update_and_create_button_access_rights_for_provider_agreements2 do
	desc "update button access rights for provider agreements"
	task :update_and_create_button_access_rights_for_provider_agreements2 => :environment do



		#compliance officer role_id(12)
		# Manager role_id(6)
		# Supervisorrole_id(5)
		#for "Request For Approval" button
		AccessRight.where("role_id = 12 and ruby_element_id = 690").update_all(access:'Y')#update
		AccessRight.create(role_id: 6 , ruby_element_id: 690,access:'Y', created_at: Time.now, updated_at: Time.now)#create
		#for "Reject" button
		AccessRight.where("role_id = 5 and ruby_element_id = 691").update_all(access:'Y')#update
		AccessRight.where("role_id = 12 and ruby_element_id = 691").update_all(access:'N')#update
		AccessRight.create(role_id: 6 , ruby_element_id: 691,access:'Y', created_at: Time.now, updated_at: Time.now)#create


  end
end