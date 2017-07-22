namespace :ruby_elements_access_rights_for_skills_and_barriers  do
	desc "ruby elements access rights for skills and barriers "
	task :ruby_elements_access_rights_for_skills_and_barriers  => :environment do


        AccessRight.where("ruby_element_id in (46,47,48,49)").update_all("access = 'N'")

	end
end