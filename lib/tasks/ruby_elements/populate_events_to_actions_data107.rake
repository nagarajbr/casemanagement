namespace :populate_events_to_actions_data107 do
	desc "program unit transfer - create task for case manager."
	task :populate_events_to_actions_data107 => :environment do
		EventToActionsMapping.create(event_type:930,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:6766 ,created_by: 1,updated_by: 1,enable_flag: 'Y') #6766-program unit transfer task
	end
end