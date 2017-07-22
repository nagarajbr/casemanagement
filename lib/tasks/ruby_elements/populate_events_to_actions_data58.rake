namespace :populate_events_to_actions_data58 do
	desc "event to actions mappings for first time program unit approval after approving career plan"
	task :populate_events_to_actions_data58 => :environment do
		EventToActionsMapping.create(event_type:740,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:30,task_type:6607 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:740,action_type:6446,method_name:"AlertService.create_alert",sort_order:40,task_type:6607 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end
