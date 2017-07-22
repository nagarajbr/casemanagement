namespace :populate_events_to_actions_data102 do
	desc "additional action for event to actions mappings for Application processing queue"
	task :populate_events_to_actions_data102 => :environment do
		EventToActionsMapping.create(event_type:866,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:20,created_by: 1,updated_by: 1,task_type: 6593,enable_flag: 'Y')
	end
end