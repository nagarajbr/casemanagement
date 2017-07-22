namespace :events_to_actions_mapping2 do
	desc "Events to Actions Mapping Data2"
	task :events_to_actions_mapping2 => :environment do
		EventToActionsMapping.create(event_type:6447,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:6386 ,created_by: 1,updated_by: 1)

	end
end