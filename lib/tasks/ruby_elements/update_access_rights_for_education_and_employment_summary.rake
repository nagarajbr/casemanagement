namespace :update_access_rights_for_education_and_employment_summary do
	desc "Updating access rights for education and employment summary is 'N' for all users "
	task :update_access_rights_for_education_and_employment_summary => :environment do
#ruby_element_id 32-"Education Summary" ,35-"Employment Summary"
	AccessRight.where("role_id in (2,3,4,5,8,7,12) and ruby_element_id in (32,35)").update_all("access = 'N'")


   end
end