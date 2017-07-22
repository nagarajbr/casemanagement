namespace :events_to_actions_mapping50 do
	desc "Events to Actions Mapping Data50"
	task :events_to_actions_mapping50 => :environment do
		EventToActionsMapping.create(event_type:243,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:30,task_type:6593 ,enable_flag:'Y',created_by: 1,updated_by: 1)
	end
end