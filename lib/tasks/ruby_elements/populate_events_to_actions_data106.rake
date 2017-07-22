namespace :populate_events_to_actions_data106 do
	desc "event to action mappings change in assessment by non case manager"
	task :populate_events_to_actions_data106 => :environment do
		EventToActionsMapping.create(event_type:732,action_type:6445,method_name:"WorkTaskService.create_work_task",task_type:6764 ,sort_order:10,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end