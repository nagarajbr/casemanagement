namespace :populate_events_to_actions_data76 do
	desc "tea_diversion_assessment_complete_create_task"
	task :populate_events_to_actions_data76 => :environment do
		EventToActionsMapping.where("event_type = 740 and method_name = 'AlertService.create_alert' and task_type = 6607").update_all(method_name:"WorkTaskService.create_work_task",task_type:6633)

	end
end