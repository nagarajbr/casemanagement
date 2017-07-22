namespace :populate_events_to_actions_data109 do
	desc "event to action mappings entry to move program unit from ED queue to work rediness assessment"
	task :populate_events_to_actions_data109 => :environment do
		EventToActionsMapping.create(event_type:683,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:20,task_type:6386 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:683,action_type:6586,method_name:"QueueService.create_queue",sort_order:30,queue_type:6559 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end