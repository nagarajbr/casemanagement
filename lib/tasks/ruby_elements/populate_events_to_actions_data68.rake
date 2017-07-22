namespace :populate_events_to_actions_data68 do
	desc "event to action mappings entry to complete work on rejected cpp task on click of request to approve cpp"
	task :populate_events_to_actions_data68 => :environment do
		EventToActionsMapping.create(event_type:291,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:30,task_type:6464 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end