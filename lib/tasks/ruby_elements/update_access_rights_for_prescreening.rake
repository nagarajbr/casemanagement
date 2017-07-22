namespace :update_access_rights_for_prescreening  do
	desc "Updating access rights for  prescreening "
	task :update_access_rights_for_prescreening  => :environment do


	AccessRight.where("ruby_element_id in (1,2,3)").update_all("access = 'N'")


   end
end