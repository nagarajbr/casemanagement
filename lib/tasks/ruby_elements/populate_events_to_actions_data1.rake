namespace :events_to_actions_mapping1 do
	desc "Events to Actions Mapping Data"
	task :events_to_actions_mapping1 => :environment do
		EventToActionsMapping.create(event_type:6444,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:2178 ,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:6444,action_type:6446,method_name:"AlertService.create_alert",sort_order:20,task_type:2178 ,created_by: 1,updated_by: 1)
	end
end

