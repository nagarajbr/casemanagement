namespace :populate_events_to_actions_data72 do
	desc "event to action mappings entry to complete ED task for child only case type"
	task :populate_events_to_actions_data72 => :environment do
		EventToActionsMapping.create(event_type:682,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:20,task_type:6346 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end