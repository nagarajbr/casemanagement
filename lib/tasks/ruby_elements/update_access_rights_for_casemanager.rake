namespace :update_access_rights_for_casemanager do
	desc "Updating access rights for casemanager "
	task :update_access_rights_for_casemanager => :environment do


	AccessRight.where("role_id = 4 and ruby_element_id in (138,139,140,143,144)").update_all("access = 'N'")


   end
end