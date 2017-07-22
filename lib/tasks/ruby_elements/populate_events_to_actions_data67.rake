namespace :populate_events_to_actions_data67 do
	desc "event to action mappings entry to delete work queue entry on career plan reject"
	task :populate_events_to_actions_data67 => :environment do
		EventToActionsMapping.create(event_type:741,action_type:6630,method_name:"QueueService.delete_queue",sort_order:30,queue_type:6561 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end