namespace :events_to_actions_queue_mapping1 do
	desc "Events to Actions Mapping for sanctions"
	task :events_to_actions_queue_mapping1 => :environment do
		EventToActionsMapping.where("event_type = 747 and task_type = 6346").destroy_all

		EventToActionsMapping.create(event_type:662,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:10,task_type:6387 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:662,action_type:6586,method_name:"QueueService.create_queue",sort_order:20,queue_type:6560 ,created_by: 1,updated_by: 1,enable_flag: 'Y')


	end
end