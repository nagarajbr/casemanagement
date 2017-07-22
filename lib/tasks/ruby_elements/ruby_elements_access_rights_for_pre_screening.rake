namespace :ruby_elements_access_rights_for_pre_screening  do
	desc "ruby elements access rights for pre screening  "
	task :ruby_elements_access_rights_for_pre_screening  => :environment do
        AccessRight.where("ruby_element_id in (1,2,3)").update_all("access = 'Y'")

	end
end