namespace :access_right_for_pre_screening_and_provider_removed do
	desc "Access right for pre-screening and providers is removed "
	task :access_right_for_pre_screening_and_provider_removed => :environment do
	 AccessRight.where("ruby_element_id in (1,170)").update_all(access: 'N')
	 end
end