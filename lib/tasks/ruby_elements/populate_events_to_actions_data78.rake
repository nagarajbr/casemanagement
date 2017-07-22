namespace :populate_events_to_actions_data78 do
	desc "tea_diversion_assessment_complete_create_task"
	task :populate_events_to_actions_data78 => :environment do
		EventToActionsMapping.where("event_type = 662 and method_name = 'AlertService.create_alert' and task_type = 6633").update_all(method_name:"WorkTaskService.create_work_task",enable_flag:'Y',action_type:6445)

	end
end