namespace :populate_events_to_actions_data81 do
	desc "on reject of benefit amount alert not needed"
	task :populate_events_to_actions_data81 => :environment do
		EventToActionsMapping.where("event_type = 740 and method_name = 'WorkTaskService.create_work_task' and task_type = 6633").update_all(sort_order: 50)
	end
end

