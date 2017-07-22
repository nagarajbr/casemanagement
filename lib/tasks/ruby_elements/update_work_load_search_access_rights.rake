namespace :update_work_load_search_access_rights do
	desc "update work load search access rights"
	task :update_work_load_search_access_rights => :environment do


		AccessRight.create(role_id: 12, ruby_element_id: 721 ,  access:'Y', created_at: Time.now, updated_at: Time.now)# compliance officer
		AccessRight.create(role_id: 12, ruby_element_id: 722 ,  access:'Y', created_at: Time.now, updated_at: Time.now)# compliance officer
		AccessRight.where("role_id = 3 and ruby_element_id = 721").update_all(access:'N')#intake worker
		AccessRight.where("role_id = 3 and ruby_element_id = 722").update_all(access:'N')#intake worker

		AccessRight.where("role_id = 4 and ruby_element_id = 721").update_all(access:'N')#"Case Manager"
		AccessRight.where("role_id = 4 and ruby_element_id = 722").update_all(access:'N')#"Case Manager"

		AccessRight.where("role_id = 7 and ruby_element_id = 721").update_all(access:'N')#QA
		AccessRight.where("role_id = 7 and ruby_element_id = 722").update_all(access:'N')#QA





	end
end