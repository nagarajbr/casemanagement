namespace :populate_events_to_actions_data85 do
	desc "event to action mappings complete cpp on reject2"
	task :populate_events_to_actions_data85 => :environment do
		

		EventToActionsMapping.create(event_type:838,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:30,task_type:6607 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		
	end
end

