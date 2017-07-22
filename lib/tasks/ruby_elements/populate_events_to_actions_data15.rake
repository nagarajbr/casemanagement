namespace :events_to_actions_mapping15 do
	desc "Deleting event id 6500"
	task :events_to_actions_mapping15 => :environment do
		EventToActionsMapping.where("event_type = 6500").destroy_all
	end
end