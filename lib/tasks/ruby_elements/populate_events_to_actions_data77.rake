namespace :populate_events_to_actions_data77 do
	desc "event to action mappings complete request for first time benefit amount when request button is clicked"
	task :populate_events_to_actions_data77 => :environment do
		EventToActionsMapping.create(event_type:682,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:30,task_type:6633 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end