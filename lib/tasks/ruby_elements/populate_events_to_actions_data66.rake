namespace :populate_events_to_actions_data66 do
	desc "event to action mappings entry to move program unit from employment planning to approved career plan for PGU"
	task :populate_events_to_actions_data66 => :environment do
		EventToActionsMapping.create(event_type:740,action_type:6586,method_name:"QueueService.create_queue",sort_order:30,queue_type:6625 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:740,action_type:6586,method_name:"QueueService.create_queue",sort_order:40,queue_type:6626 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end