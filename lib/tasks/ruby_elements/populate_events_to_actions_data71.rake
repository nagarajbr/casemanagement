namespace :populate_events_to_actions_data71 do
	desc "event to action mappings entry to move Open program unit from Approve First Time Benefit Amount Queue "
	task :populate_events_to_actions_data71 => :environment do
		EventToActionsMapping.create(event_type:736,action_type:6586,method_name:"QueueService.create_queue",sort_order:110,queue_type:6616 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end