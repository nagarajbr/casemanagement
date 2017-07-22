namespace :changes_for_application_processing_steps do
	desc "soft delete step 8 to make it total of 7 steps for application processing"
	task :changes_for_application_processing_steps => :environment do
		AccessRight.where("ruby_element_id in (856,860,861)").update_all(access:'N')
		RubyElementReltn.where("child_element_id = 858").update_all(child_order: 60)
		RubyElementReltn.where("child_element_id = 859").update_all(child_order: 40)
		RubyElementReltn.where("child_element_id = 857").update_all(child_order: 50)
	end
end