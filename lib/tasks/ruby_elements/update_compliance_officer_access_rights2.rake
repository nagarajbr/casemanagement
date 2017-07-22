namespace :access_rights_for_compliance_officer2 do
	desc "Updating access rights for compliance officer2 "
	task :update_access_rights_compliance_officer2 => :environment do
		AccessRight.where("role_id = 12 and ruby_element_id in (135,136,137)").update_all("access = 'Y'")
	end
end
