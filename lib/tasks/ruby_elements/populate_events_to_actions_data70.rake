namespace :populate_events_to_actions_data70 do
	desc "event to action mappings entry to move program unit from request for approval to approved cpp on reject"
	task :populate_events_to_actions_data70 => :environment do
		EventToActionsMapping.create(event_type:737,action_type:6586,method_name:"QueueService.create_queue",sort_order:40,queue_type:6626 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end