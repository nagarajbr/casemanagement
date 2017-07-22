namespace :update_access_rights_for_request_for_approval_button do
	desc "Updating access rights"
	task :update_access_rights_for_request_for_approval_button => :environment do


	AccessRight.where("role_id = 3 and ruby_element_id = 690").update_all("access = 'Y'")


   end
end