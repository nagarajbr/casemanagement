namespace :populate_events_to_actions_data108 do
	desc "Assign to me work task."
	task :populate_events_to_actions_data108 => :environment do
		EventToActionsMapping.create(event_type:746,action_type:6525,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:6386 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end