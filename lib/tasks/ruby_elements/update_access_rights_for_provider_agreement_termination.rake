namespace :update_access_rights_for_provider_agreement_termination do
	desc "Updating access rights for provider agreement termination button acces "
	task :update_access_rights_for_provider_agreement_termination => :environment do


	AccessRight.where("role_id in (5) and ruby_element_id in (688)").update_all("access = 'Y'")
	AccessRight.where("role_id in (12) and ruby_element_id in (688)").update_all("access = 'N'")
	AccessRight.create(role_id: 6, ruby_element_id: 688,  access:'Y', created_at: Time.now, updated_at: Time.now)


   end
end