namespace :populate_events_to_actions_application_queue do
	desc "populate_events_to_actions_application_queue"
	task :populate_events_to_actions_application_queue => :environment do
		EventToActionsMapping.where("event_type = 684
									and task_type = 6344
									").update_all(action_type: 6586,
    											   method_name: 'QueueService.create_queue',
    											   task_type: nil,
    											   queue_type: 6559
    											   )
	end
end