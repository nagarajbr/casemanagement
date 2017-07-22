namespace :events_to_actions_mapping10 do
	desc "Events to Actions Mapping Data10"
	task :events_to_actions_mapping10 => :environment do
		EventToActionsMapping.create(event_type:6499,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:10,task_type:6346 ,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:6499,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:20,task_type:6344 ,created_by: 1,updated_by: 1)
	end
end