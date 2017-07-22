namespace :events_to_actions_mapping62 do
	desc "Events to Actions Mapping for request to approve cpp"
	task :events_to_actions_mapping62 => :environment do
		# EventToActionsMapping.create(event_type:291,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:10,task_type:6605 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.where("event_type = 291 and task_type = 6463").update_all(action_type:6458,method_name:"WorkTaskService.complete_work_task",task_type:6605)
		EventToActionsMapping.create(event_type:291,action_type:6586,method_name:"QueueService.create_queue",sort_order:20,queue_type:6561,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end