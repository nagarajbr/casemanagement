namespace :update_access_rights_for_service_approval  do
	desc "Updating access rights for service approval"
	task :update_access_rights_for_service_approval  => :environment do
		AccessRight.where("ruby_element_id in (208,209)").update_all("access = 'N'")
   end
end