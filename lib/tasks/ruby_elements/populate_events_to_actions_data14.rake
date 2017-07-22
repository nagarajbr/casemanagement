namespace :events_to_actions_mapping14 do
	desc "Events to Actions Mapping Data14"
	task :events_to_actions_mapping14 => :environment do
		EventToActionsMapping.create(event_type:747,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:30,task_type:6346 ,created_by: 1,updated_by: 1)
	end
end