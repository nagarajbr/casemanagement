namespace :events_to_actions_mapping54 do
	desc "Events to Actions Mapping for provider agreement reject"
	task :events_to_actions_mapping54 => :environment do
		EventToActionsMapping.create(event_type:691,action_type:6446,method_name:"AlertService.create_alert",sort_order:30,task_type:6603,created_by: 1,updated_by: 1,enable_flag: 'Y')

	end
end