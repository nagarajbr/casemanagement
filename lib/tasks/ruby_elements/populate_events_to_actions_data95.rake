namespace :populate_events_to_actions_data95 do
	desc "event to action mappings to delete a queue"
	task :populate_events_to_actions_data95 => :environment do
		EventToActionsMapping.create(event_type:692,action_type:6630,method_name:"QueueService.delete_queue",sort_order:30,created_by: 1,updated_by: 1,enable_flag: 'Y',queue_type: 6654)
	end
end