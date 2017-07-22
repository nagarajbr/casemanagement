namespace :populate_events_to_actions_data69 do
	desc "event to action mappings of queue first time benefit approval"
	task :populate_events_to_actions_data69 => :environment do
		EventToActionsMapping.where("event_type = 682 and action_type = 6445 and task_type = 2172").update_all(queue_type:6562,task_type:nil,method_name:"QueueService.create_queue",action_type:6586)
	end
end