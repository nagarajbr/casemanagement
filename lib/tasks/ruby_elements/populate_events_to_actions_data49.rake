namespace :events_to_actions_mapping49 do
	desc "Events to Actions Mapping Data49"
	task :events_to_actions_mapping49 => :environment do
		EventToActionsMapping.create(event_type:309,action_type:6458,method_name:"WorkTaskService.create_work_task",sort_order:20,task_type:6593 ,enable_flag:'Y',created_by: 1,updated_by: 1)
	end
end