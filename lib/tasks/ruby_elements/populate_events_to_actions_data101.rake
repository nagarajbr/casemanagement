namespace :populate_events_to_actions_data101 do
	desc "disabling Application processing queue"
	task :populate_events_to_actions_data101 => :environment do
		EventToActionsMapping.where("event_type = 243 and action_type in (6586,6458)").update_all(enable_flag: 'N')
	end
end