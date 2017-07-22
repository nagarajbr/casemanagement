namespace :populate_events_to_actions_data43 do
	desc "event to action mappings entries application queue"
	task :populate_events_to_actions_data43 => :environment do
		EventToActionsMapping.create(event_type:309,action_type:6586,method_name:"QueueService.create_queue",sort_order:10,queue_type:6557 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end