namespace :deleting_duplicate_entry_for_resource_value do
	desc "deleting_duplicate_entry_for_resource_value"
	task :delete_ruby_entry => :environment do
		RubyElement.where("id = 761").destroy_all
		EventToActionsMapping.where("event_type = 761").destroy_all
	end
end