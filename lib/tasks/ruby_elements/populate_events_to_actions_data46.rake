namespace :populate_events_to_actions_data46 do
	desc "deleting extra alert event to action mappings entry for first time program unit activation"
	task :populate_events_to_actions_data46 => :environment do
		EventToActionsMapping.where("event_type = 736 and action_type = 6446 and sort_order = 80 and task_type = 2172").destroy_all
	end
end