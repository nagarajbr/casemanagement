namespace :populate_events_to_actions_data96 do
	desc "event to action mappings to delete a queue"
	task :populate_events_to_actions_data96 => :environment do
		EventToActionsMapping.create(event_type:549,action_type:6630,method_name:"QueueService.delete_queue",sort_order:30,created_by: 1,updated_by: 1,enable_flag: 'Y',queue_type: 6654)
	end
end