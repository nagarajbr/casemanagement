namespace :populate_events_to_actions_data56 do
	desc "adding client model field change attributes to ruby elements"
	task :populate_events_to_actions_data56 => :environment do
		EventToActionsMapping.create(event_type:759,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:759,action_type:6525,method_name:"ClientEntityService.ed_entry_for_client_death_date_info",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end
