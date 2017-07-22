namespace :access_rights_for_provider_agreements  do
	desc "provider_agreements access rights "
	task :provider_agreements_access_rights  => :environment do
        #access rights
        AccessRight.create(role_id:6, ruby_element_id: 541,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:6, ruby_element_id: 542,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:6, ruby_element_id: 543,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:6, ruby_element_id: 689,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.where("ruby_element_id = 688 and id = 1976").update_all("access = 'N'")
        AccessRight.where("ruby_element_id = 690 and id in (1978,3714,2489)").update_all("access = 'N'")
        AccessRight.where("ruby_element_id = 541 and id = 3708").update_all("access = 'N'")
        AccessRight.where("ruby_element_id = 542 and id = 3709").update_all("access = 'N'")
        AccessRight.where("ruby_element_id = 543 and id = 3710").update_all("access = 'N'")





	end
end