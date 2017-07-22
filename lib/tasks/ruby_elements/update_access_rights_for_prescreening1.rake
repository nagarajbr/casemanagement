namespace :update_access_rights_for_prescreening1  do
	desc "Updating access rights for  prescreening "
	task :update_access_rights_for_prescreening1  => :environment do


	AccessRight.where("ruby_element_id in (1,2,3)").update_all("access = 'Y'")


   end
end