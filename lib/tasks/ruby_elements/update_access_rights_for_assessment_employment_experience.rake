
namespace :update_access_rights_for_assessment_employment_experience do
	desc "Updating access rights for assessment - employment/experience should not be shown "
	task :update_access_rights_for_assessment_employment_experience => :environment do


	AccessRight.where("id in (94,298,706,3235) and ruby_element_id = 93 ").update_all("access = 'N'")


   end
end