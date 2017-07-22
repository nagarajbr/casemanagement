namespace :populate_events_to_actions_data74 do
	desc "tea_diversion_assessment_complete_create_task"
	task :populate_events_to_actions_data74 => :environment do
		EventToActionsMapping.where("event_type = 662 and method_name = 'AlertService.create_alert'").update_all(method_name:"AlertService.create_alert",enable_flag:'N')

	end
end