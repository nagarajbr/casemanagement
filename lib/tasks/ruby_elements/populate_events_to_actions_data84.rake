namespace :populate_events_to_actions_data84 do
	desc "event to action mappings complete cpp on reject"
	task :populate_events_to_actions_data84 => :environment do
		

		EventToActionsMapping.create(event_type:838,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:15,task_type:6464 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		
	end
end