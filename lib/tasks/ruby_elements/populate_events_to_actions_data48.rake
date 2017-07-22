namespace :populate_events_to_actions_data48 do
	desc "event to actions mappings entries for adding determine eligibility queue"
	task :populate_events_to_actions_data48 => :environment do
		EventToActionsMapping.where("event_type = 243
									and task_type = 6386
									").update_all(action_type: 6586,
    											   method_name: 'QueueService.create_queue',
    											   task_type: nil,
    											   queue_type: 6558
    											   )
	end
end


