namespace :populate_events_to_actions_data52 do
	desc "populate_events_to_actions_data52"
	task :populate_events_to_actions_data52 => :environment do
		EventToActionsMapping.where("event_type = 746 and task_type = 6386 ").destroy_all
	end
end