 namespace :delete_ruby_elements_and_application_access_rights do
	desc "delete ruby elements and application access rights for work task category"
	task :delete_ruby_elements_and_application_access_rights => :environment do

	RubyElement.where("id in (869,871,873,874,876,877,878,879,890,899,909)").destroy_all
    ApplicationAccessRight.where("ruby_element_id in (869,871,873,874,876,877,878,879,890,899,909)").destroy_all

  end
 end
