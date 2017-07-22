namespace :update_access_rights_for_submit_summary_of_check_eligibility do
	desc "Updating access rights for casemanager for submit summary of check eligibility"
	task :update_access_rights_for_submit_summary_of_check_eligibility => :environment do


	AccessRight.where("role_id in (2,3,5,8,7,12) and ruby_element_id in (73,74)").update_all("access = 'N'")


   end
end