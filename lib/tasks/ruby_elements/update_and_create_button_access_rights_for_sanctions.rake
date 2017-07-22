namespace :update_and_create_button_access_rights_for_sanctions do
	desc "update button access rights for sanctions"
	task :update_and_create_button_access_rights_for_sanctions => :environment do

		#sanctions "New" button
		AccessRight.create(role_id: 6 , ruby_element_id: 595,access:'Y', created_at: Time.now, updated_at: Time.now)#create
		#sanctions "Edit" button
		AccessRight.create(role_id: 6 , ruby_element_id: 596,access:'Y', created_at: Time.now, updated_at: Time.now)#create
		#sanctions "Delete" button
        AccessRight.create(role_id: 6 , ruby_element_id: 597,access:'Y', created_at: Time.now, updated_at: Time.now)#create

		#sanction details "Edit button"
		AccessRight.where("role_id = 4 and ruby_element_id = 599").update_all(access:'N')#update
		AccessRight.where("role_id = 5 and ruby_element_id = 599").update_all(access:'N')#update
		AccessRight.create(role_id: 6 , ruby_element_id: 599,access:'N', created_at: Time.now, updated_at: Time.now)#create



		#sanction details "Delete button"
		AccessRight.where("role_id = 4 and ruby_element_id = 600").update_all(access:'N')#update
		AccessRight.where("role_id = 5 and ruby_element_id = 600").update_all(access:'N')#update
		AccessRight.create(role_id: 6 , ruby_element_id: 600,access:'N', created_at: Time.now, updated_at: Time.now)#create

         #sanction details "Add Details" button
		AccessRight.create(role_id: 6 , ruby_element_id: 598,access:'N', created_at: Time.now, updated_at: Time.now)#create

	end
end
