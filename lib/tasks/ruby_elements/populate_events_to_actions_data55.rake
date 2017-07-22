namespace :events_to_actions_mapping55 do
	desc "Events to Actions Mapping for provider payment reject"
	task :events_to_actions_mapping55 => :environment do
		EventToActionsMapping.create(event_type:742,action_type:6446,method_name:"AlertService.create_alert",sort_order:30,task_type:6604,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end