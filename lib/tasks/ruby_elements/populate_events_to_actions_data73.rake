namespace :populate_events_to_actions_data73 do
	desc "event to action mappings entry alert first time benefit amount request for child only case type"
	task :populate_events_to_actions_data73 => :environment do
		EventToActionsMapping.create(event_type:662,action_type:6446,method_name:"AlertService.create_alert",sort_order:30,task_type:6633 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end