namespace :populate_events_to_actions_data60 do
	desc "event to actions mappings for first time program unit benefit reject"
	task :populate_events_to_actions_data60 => :environment do
		EventToActionsMapping.create(event_type:737,action_type:6446,method_name:"AlertService.create_alert",sort_order:30,task_type:6612 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end